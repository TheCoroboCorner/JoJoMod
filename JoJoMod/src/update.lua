
                            -- PARAMETERS TO SET --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local modPath = "Mods/JoJoMod" -- This is the path to your mod folder

local id = "JoJoMod" -- This is the ID of your mod -- the same one you put in your metadata file

local subpath = "JoJoMod" -- Some mods have additional folders for you to dig through once you open the zip.
						  -- In this case, mine is named JoJoMod because I zip the folder instead of the contents.
						  -- Put a value here if you have a similar thing for yours, but you can comment it out otherwise.
						  
local download_suffix = "Release.zip" -- The file in question to download - commenting it out means you want the default file

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Fetches the body of the given url using Curl.
--- 	The URL in question is inputted, then it outputs the corresponding JSON file for its body component.
local function curl_fetch(url)
	local cmd = ('curl -sL "%s"'):format(url:gsub('"','\\"'))
	local fp = io.popen(cmd, "r")
	if not fp then return nil, "curl not available" end
	local body = fp:read("*a")
	local ok, _, exit = fp:close()
	if not ok then return nil, ("curl exited with code %s"):format(tostring(exit)) end
	return body
end

--- Parses the json file inputted and outputs relevant parameters (tag, asset url).
---		The tag is used to check the version type, and the asset url is used to download
--- the exact file in the download_suffix parameter you set up at the top.
local function parse_release(body)
	local tag =  body:match('"tag_name"%s*:%s*"([^"]+)"')
	if not tag then return nil, nil, "Could not find tag_name" end
	
	if download_suffix then
		for name, url in body:gmatch('"name"%s*:%s*"([^"]+)"[^}]-"browser_download_url"%s*:%s*"([^"]+)"') do
			if name == download_suffix then
				return tag, url, nil
			end
		end
		return tag, nil, "Specified asset not found"
	else
		return tag, nil, nil
	end
end

--- Returns the tag and asset_url of the mod you specified in your metadata file with the git_owner and git_repo slots.
---		It constructs the URL of the Github project associated with the name and repo listed,
--- then it feeds that through to parse_release() and returns what it has.
function check_version()
	local owner, repo = SMODS.Mods[id].git_owner, SMODS.Mods[id].git_repo
	
	if not owner then return nil, "git_owner parameter not found in metadata json file" end
	if not repo then return nil, "git_repo parameter not found in metadata json file" end
	
	local url = string.format("https://api.github.com/repos/%s/%s/releases/latest", owner, repo)
	
	local body, err = curl_fetch(url)
	if not body then
		print("Fetch failed:", err)
		return nil
	end
	
	local tag, asset_url, perr = parse_release(body)
	if not tag then
		print("Couldn't parse JSON - tag_name missing")
		return nil, nil, perr
	end
	
	return tag, asset_url, nil
end

--- Downloads the file in question using Curl.
---		It accesses the Github repo you specified earlier and either downloads the item you specified with the
---	download_suffix parameter, or it does the default, whatever that may be (though the default is fine, it does
---	seem to work fine, at least for me).
local function download_file(url, dest_path)
	local cmd = ('curl -sL -A "ModUpdater" -o "%s" "%s"'):format(dest_path, url)
	local success = os.execute(cmd)
	return success == true or success == 0
end

--- Accesses the first available subfolder to the path in question.
local function get_subdir(path)
	for entry in io.popen('dir "' .. path .. '" /b /ad'):lines() do
		return entry
	end
end

--- Unzips the zip file in question and places it in the correct directory.
---		Windows-based and Unix-based systems work different, so you do have to differentiate them first, but
---	in the Windows section, it first deletes whatever files are in the target location (make sure to have a backup!)
--- just so there's no issues with replacing files. Next, it unzips the zip file into a temp folder, then it unzips
--- the specified subdirectory (or just the whole thing if no subdirectory is specified) into the target location.
--- Finally, it deletes the temp folder and the zip file, and renames the folder if it can, to the target name (just
--- in case no subdirectory was mentioned). 
--- Linux is similar, except it has the functionality of the first few steps built-in, if I'm reading this right.
local function unzip_file(zip_path)
	modPath = modPath:gsub("/", "\\")
	zip_path = zip_path:gsub("/", "\\")

	local is_windows = package.config:sub(1,1) == '\\'
	local tmp_dir = modPath .. "_tmp"
	local ok1, ok2, ok3
	
	if is_windows then
		os.execute(('if exist "%s" rmdir /S /Q "%s"'):format(tmp_dir, tmp_dir))
		os.execute(('if exist "%s" rmdir /S /Q "%s"'):format(modPath, modPath))
		ok1 = os.execute(string.format('powershell -NoProfile -Command "Expand-Archive -LiteralPath %q -DestinationPath %q -Force"', zip_path, tmp_dir))
		
		local subfolder = get_subdir(tmp_dir)
		if subfolder then
			local src_path = subpath and tmp_dir .. "\\" .. subfolder .. "\\" .. subpath or tmp_dir .. "\\" .. subfolder
			ok2 = os.execute(string.format('powershell -NoProfile -Command "Move-Item -Path %q -Destination %q -Force"', src_path, modPath))
		else 
			ok2 = false
		end
		
		ok3 = os.execute(string.format('rmdir /S /Q "%s"', tmp_dir))
	else
		ok1 = os.execute(string.format('unzip -o %q %q\'*\' -d %q', zip_path, subpath and string.format("%s-%s\\%s", repo, tag, subpath) or string.format("%s-%s", repo, tag), modPath))
		ok2 = true
		ok3 = true
	end
	
	local ok4 = os.remove(zip_path)
	os.rename(string.sub(zip_path, -4), modPath:match("\\([^\\]+)$"))
	
	return  (ok1 == true or ok1 == 0) and
			(ok2 == true or ok2 == 0) and
			(ok3 == true or ok3 == 0) and
			ok4 == true
	
end

--- Downloads, unzips, and installs the latest update for the mod in question.
--- 	First, it locates your git_owner and git_repo parameters in your metadata file. These are
--- your Github username and your Github repository name, respectively. Next, it gathers the tag and
--- asset url, so it can install the correct update and the correct file for that update. Then, it
--- constructs the correct URL, attempts to download it using the download_file function, attempts to
--- unzip it using the unzip_file function, and if everything is successful, it restarts the game.
local function install_update()
	local owner, repo = SMODS.Mods[id].git_owner, SMODS.Mods[id].git_repo
	local tag, asset_url, err = check_version()
	if not tag then
		print("Version check failed:", err)
		return
	end
	
	local zip_url = asset_url or string.format("https://github.com/%s/%s/archive/%s.zip", owner, repo, tag)
	local zip_path = ("Mods\\%s-%s.zip"):format(repo, tag)
	
	if not download_file(zip_url, zip_path) then
		print("Failed to download update from " ..zip_url)
		return
	end
	
	if not unzip_file(zip_path) then
		print("Failed to unzip " ..zip_path)
		return
	end
	
	SMODS.restart_game()
end

--- Installs the update when the 'Yes' confirmation button is pressed in the update prompt screen.
--- 	G.FUNCS.exit_overlay_menu() is there in case something goes wrong, so that it'll close anyway.
G.FUNCS.update_accepted = function(e)
	install_update()
	G.FUNCS.exit_overlay_menu()
end

--- Closes the menu when the 'No' confirmation button is pressed in the update prompt screen.
--- 	I tried just setting it to G.FUNCS.exit_overlay_menu directly, but it didn't seem to work, so
--- now we have this.
G.FUNCS.update_denied = function(e)
	G.FUNCS.exit_overlay_menu()
end

--- Displays the choice prompt to update the specified mod.
--- 	 It first instantiates each line of the message. I was going to have these be different text nodes
--- originally, but I couldn't figure out how to do it properly and gave up and just used a box node to fix it.
--- After the text is instantiated, it moves onto the singular text node in question, then following with the
--- buttons, and ending with the root node (It feels really messy to have all the nested tables in one place,
--- so I did this). Finally, it overlays the menu on the screen.
local function show_update_prompt(latest, current)
	local msg = {
		("A new version of %s is available!\n"):format(SMODS.Mods[id].name),
		("Installed: %s\n"):format(current),
		("Latest:    %s\n\n"):format(latest),
		"Update now? (This will restart Balatro.)"
	}
	
	local lines = {
		n = G.UIT.R,
		config = {
			padding = 0.2,
			align = "tm"
		},
		nodes = {
			{
				n = G.UIT.C,
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = msg[1] .. msg[2] .. msg[3] .. msg[4], -- Really, this is kinda redundant, but I'm lazy and it doesn't really do any harm, so...
							scale = 0.5
						}
					},
				}
			}
		}
	}
	
	local button_row = {
		n = G.UIT.R,
		config = {
			padding = 0.2,
			align = "bm"
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.1
				},
				nodes = {
					UIBox_button {
						colour = G.C.GREEN,
						label = { "Yes" },
						button = "update_accepted",
					}
				}
			},
			{
				n = G.UIT.C,
				config = {
					padding = 0.1
				},
				nodes = {
					UIBox_button {
						colour = G.C.RED,
						label = { "No" },
						button = "update_denied",
					}
				}
			}
		}	
	}
	local confirm_ui = {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			minw = 4,
			minh = 5,
			padding = 0.3,
			colour = G.C.UI.TEXT_DARK,
			outline = 5,
			outline_colour = G.C.BLACK,
			r = 0.1
		},
		nodes = {
			lines,
			{
				n = G.UIT.R,
				nodes = {
					{
						n = G.UIT.B,
						config = {
							h = 2,
							w = 0
						}
					}
				}
			},
			button_row
		}
	}
	G.FUNCS.overlay_menu {
		definition = confirm_ui,
		config = {
			align = "cm",
			bond = "Weak",
			no_esc = true,
			major = G.ROOM_ATTACH
		}
	}
end

--- Compares the current version of the specified mod and the latest version on Github, sending the update prompt
--- if the current version is outdated.
--- 	The pattern matching essentially reduces the version type down to a "1.2.3" or "1.2.3a" type of deal. It'section
--- a lot easier to compare that way (using V), and it even works for alpha/beta versions. Sometimes, if there are
--- connection errors, check_version() will return nil, so there has to be a null check at the start there.
JOJO.update_check = function()
	local raw_version = check_version()
	if not raw_version then return nil, "There appears to have been a connection error" end
	
	local git_version = raw_version:match("^v?(%d+%.%d+%.%d+%a*)$")
	
	local current_version = SMODS.Mods[id].version:match("^v?(%d+%.%d+%.%d+%a*)$")
	
	if git_version and current_version and V(git_version) > V(current_version) then
		show_update_prompt('v' .. git_version, 'v' .. current_version)
	end
end
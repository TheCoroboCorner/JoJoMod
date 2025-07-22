local bit = require("bit")

                            -- PARAMETERS TO SET --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local git_owner = "TheCoroboCorner" -- This is the Github username to look up for the repository
local git_repo = "JoJoMod" -- This is the name of the Github repository in question

local mod_index_id = nil -- This is an alternative to git_owner and git_repo, for if those either don't work or you don't want to use them.
						 -- As such, you only really *need* to have either this or them.

local id = "JoJoMod" -- This is the ID of your mod -- the same one you put in your metadata file

local mod_path = "Mods/JoJoMod" -- This is the path to your mod folder
local subpath = "JoJoMod" -- Some mods have additional folders for you to dig through once you open the zip.
-- OPTIONAL				  -- In this case, mine is named JoJoMod because I zip the folder instead of the contents.
						  
local download_suffix = "Release.zip" -- The file in question to download - commenting it out means you want the default file
-- OPTIONAL

local update_mandatory = false -- This is used in case a mandatory update is necessary for the mod to continue functioning (i.e. multiplayer mod)
-- OPTIONAL

local target_version = nil -- This is the version of the mod that's preferred -- no need to touch this, this is for modpacks to touch
-- OPTIONAL

-- Setting them here is no longer functional -- you set them directly in your metadata file instead. It just makes it easier.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local current_mod = nil

--- Fetches the body of the given url using Curl.
--- 	The URL in question is inputted, then it outputs the corresponding JSON file for its body component.
local function curl_fetch(url)
	local cmd = ('curl -sL "%s"'):format(url:gsub('"','\\"'))
	
	local fp = io.popen(cmd, "r")
	if not fp then
		print("[PHOTON] cURL not available; stopping download checks...")
	end
	
	local body = fp:read("*a")
	
	local ok, _, exit = fp:close()
	if not ok then
		print(string.format("[PHOTON] cURL exited with code %s", tostring(exit))) 
	end
	
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

--- Checks if there is a target version specified.
local function target_version_is_valid()
	return target_version and target_version ~= '-1'
end

--- Checks if it's possible to access the GitHub repo directly.
local function direct_github_link_available()
	return git_owner and git_repo
end

--- Checks if it's possible to use the Balatro Mod Index.
local function mod_index_link_available()
	return mod_index_id
end

--- Fetches the version via the GitHub page directly.
local function fetch_version_from_github_link()
	local url = ''
	
	if target_version_is_valid() then
		url = string.format("https://api.github.com/repos/%s/%s/releases/tags/%s", git_owner, git_repo, 'v' .. target_version)
	else
		url = string.format("https://api.github.com/repos/%s/%s/releases/latest", git_owner, git_repo)
	end
	
	local ok, body = pcall(function() return curl_fetch(url) end)
	if not ok or not body then
		url = string.format("https://api.github.com/repos/%s/%s/releases/tags/%s", git_owner, git_repo, target_version)
		ok, body = pcall(function() return curl_fetch(url) end)
		if not ok or not body then
			print("[PHOTON] Fetch failed:", body)
			return nil
		end
	end
	
	local tag, asset_url, perr = parse_release(body)
	if not tag then
		if body.message == "No server is currently available to service your request. Sorry about that. Please try resubmitting your request and contact us if the problem persists." then
			print("[PHOTON] Network connection error. Connection canceled.")
		else
			print("[PHOTON] Couldn't parse JSON - tag_name missing. Error:", body.message)
		end
		return nil, nil, perr
	end
	
	return tag, asset_url, nil
end

--- Fetches the version via the Balatro Mod Manager index using the GitHub link in the metadata.
local function fetch_version_from_bmm_index()
	local index_url = "https://api.github.com/repos/skyline69/balatro-mod-index/releases/latest"

	local _, release_json = pcall(function() return curl_fetch(index_url) end)
	local release = json.decode(release_json)
	local tag = release.tag.name
	
	local meta_url = string.format("https://api.github.com/repos/skyline69/balatro-mod-index/contents/mods/%s/meta.json?ref=%s", mod_index_id, tag)
	local _, raw_json = pcall(function() return curl_fetch(meta_url) end)
	
	git_owner, git_repo = raw_json.repo:match("^github%.com[:/]+([^/]+)/([^/]+)(?:%.git)?/?$")
	
	if direct_github_link_available() then
		return fetch_version_from_github_link()
	end
	
	print("[PHOTON] Couldn't find a valid GitHub link for mod", id)
	return nil, nil, nil
end
	
--- Returns the tag and asset_url of the mod you specified in your metadata file with the git_owner and git_repo slots.
---		It constructs the URL of the Github project associated with the name and repo listed,
--- then it feeds that through to parse_release() and returns what it has.
function check_version()	
	if direct_github_link_available() then
		return fetch_version_from_github_link()
	elseif mod_index_link_available() then
		return fetch_version_from_bmm_index()
	end
end

--- Downloads the file in question using cURL.
---		It accesses the Github repo you specified earlier and either downloads the item you specified with the
---	download_suffix parameter, or it does the default, whatever that may be (though the default is fine, it does
---	seem to work fine, at least for me).
local function download_file(url, dest_path)
	local cmd = ('curl -sL -A "Photon" -o "%s" "%s"'):format(dest_path, url)
	local success = os.execute(cmd)
	return success == true or success == 0
end

--- Accesses the first available subfolder to the path in question.
local function get_subdir(path)
	for entry in io.popen('dir "' .. path .. '" /b /ad'):lines() do
		return entry
	end
end

--- Unzips the file in question for Windows-based systems.
local function unzip_windows(tmp_dir, zip_path)
	local function ok_check(ok)
		return ok == true or ok == 0
	end
	
	local ok1 = false
	local ok2 = false
	local ok3 = false
	
	mod_path = mod_path:gsub("/", "\\")
	zip_path = zip_path:gsub("/", "\\")
	
	os.execute(string.format('if exist "%s" rmdir /S /Q "%s"', tmp_dir, tmp_dir))
	os.execute(string.format('if exist "%s" rmdir /S /Q "%s"', mod_path, mod_path))
	
	ok1 = os.execute(string.format('powershell -NoProfile -Command "Expand-Archive -LiteralPath %q -DestinationPath %q -Force"', zip_path, tmp_dir))
	
	local subfolder = get_subdir(tmp_dir)
	if subfolder and ok_check(ok1) then
		local src_path = subpath and tmp_dir .. "\\" .. subfolder .. "\\" .. subpath or tmp_dir .. "\\" .. subfolder
		ok2 = os.execute(string.format('powershell -NoProfile -Command "Move-Item -Path %q -Destination %q -Force"', src_path, mod_path))
	end
	
	if ok_check(ok2) then
		ok3 = os.execute(string.format('rmdir /S /Q "%s"', tmp_dir))
	end
	
	return ok_check(ok1) and ok_check(ok2) and ok_check(ok3)
end

--- Unzips the file in question for Unix-based systems.
local function unzip_linux(zip_path)
	local function ok_check(ok)
		return ok == true or ok == 0
	end

	local command_base = 'unzip -o %q %q\'*\' -d %q'

	local proper_subpath = ''
	if subpath then
		proper_subpath = string.format("%s-%s\\%s", repo, tag, subpath)
	else
		proper_subpath = string.format("%s-%s", repo, tag)
	end

	local ok = os.execute(string.format(command_base, zip_path, proper_subpath, mod_path))
	
	return ok_check(ok)
end

--- Unzips the zip file in question and places it in the correct directory.
---		Windows-based and Unix-based systems work different, so you do have to differentiate them first, but
---	after that, it delegates them to other functions, before removing the zip file and renaming the folder.
local function unzip_file(zip_path)
	local tmp_dir = mod_path .. "_tmp"
	local is_windows = package.config:sub(1,1) == '\\'
	
	local unzip_ok = false
	if is_windows then
		unzip_ok = unzip_windows(tmp_dir, zip_path)
	else
		unzip_ok = unzip_linux(zip_path)
	end
	
	local rmdir_ok = os.remove(zip_path)
	os.rename(string.sub(zip_path, -4), mod_path:match("\\([^\\]+)$"))
	
	return unzip_ok and rmdir_ok
end

--- Downloads the latest update for the mod in question.
--- 	First, it locates your git_owner and git_repo parameters in your metadata file. These are
--- your Github username and your Github repository name, respectively. Next, it gathers the tag and
--- asset url, so it can install the correct update and the correct file for that update. Then, it
--- constructs the correct URL and attempts to download it using the download_file function.
local function download_update()
	if (git_owner and git_repo) or (mod_index_id) then
		local tag, asset_url, err = check_version()
		if not tag then
			print("[PHOTON] Version check failed:", err)
			return false, nil
		end
		
		local zip_url = asset_url or string.format("https://github.com/%s/%s/archive/%s.zip", git_owner, git_repo, tag)
		local zip_path = string.format("Mods\\%s-%s.zip", git_repo, tag)
		
		if not download_file(zip_url, zip_path) then
			print("[PHOTON] Failed to download update from " ..zip_url)
			return false, nil
		end
		
		return true, zip_path
	end
	return false, nil
end

--- Unzips and installs the latest update for the mod in question.
--- 	Attempts to unzip it using the unzip_file function, placing a check on it otherwise.
local function install_update(zip_path)
	if not unzip_file(zip_path) then
		print("[PHOTON] Failed to unzip " ..zip_path)
		return false
	end
	
	return true
end

--- Updates all the context variables to match the current mod.
--- 	These are all the variables that are mentioned at the top of the file, that you find
---	in the metadata json file. We use the local files up there mainly because we have them there
--- anyway for demonstrative purposes and it saves us the time of array-accessing current_mod.
local function update_args()
	if not current_mod then return nil end
	
	git_owner = current_mod.git_owner
	git_repo = current_mod.git_repo
	mod_index_id = current_mod.mod_index_id
	mod_path = current_mod.mod_path
	id = current_mod.id
	subpath = current_mod.subpath
	download_suffix = current_mod.download_suffix
	update_mandatory = current_mod.update_mandatory
	target_version = current_mod.target_version
end

--- Downloads, then installs the update.
--- 	restart just depends on the scenario - an individual update might want restart to be enabled,
--- but when it's in a bigger scheme, you might want to turn it off, just so you can retrigger it later.
---	mod just sets what mod to update. By default, it will do the mod in the current context (current_mod),
--- but it can be whatever mod you want.
local function update_mod(mod, restart)
	restart = restart or true
	current_mod = mod or current_mod
	update_args()
	
	local download_result, download_path = download_update()
	if not download_result then return false end
	if not install_update(download_path) then return false end
	
	if restart then SMODS.restart_game() end
	
	return true
end

--- Installs the update when the 'Yes' confirmation button is pressed in the update prompt screen.
--- 	G.FUNCS.exit_overlay_menu() is there in case something goes wrong, so that it'll close anyway.
G.FUNCS.update_accepted = function(e)
	update_mod()
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
		("A new version of %s is available!\n"):format(current_mod.name),
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

--- Returns all active mods.
--- 	While it does only get the active mods and not the inactive mods, it's not really necessary to get the
--- inactive mods, as those can be updated when they're activated (and that saves the time of trying to do a
--- web request for a mod that's going to be unused).
local function get_all_local_mods()
	local mods = {}
	for key, _ in pairs(SMODS.Mods) do
		mods[#mods + 1] = key
	end
	return mods
end

--- For each mod, it checks the response given by the update_check function and applies the appropriate flag.
--- 	up_to_date means it is the latest version that can be found on the Github page,
---		too_new means that the target version is an earlier version than the current version,
---		too_old means that the target version is a later version than the current version,
---		necessary means that the target version is a necessary version that can't be avoided,
---		err means there was an error in the process, such as an incompatible mod or bad internet connection.
---	You can parse an individual flag by just doing bit.band(mod_status[mod], flag) and it should work nicely.
local function check_available_updates()
	local mods = get_all_local_mods()
	
	-- Can't believe Lua doesn't have enums :<
	local STATUS_FLAGS = {
		up_to_date = 1,
		too_new = 2,
		too_old = 4,
		necessary = 8,
		err = 16
	}
	
	local mod_status = {}
	
	for _, mod in ipairs(mods) do
		local args = SMODS.Mods[mod]
		
		JOJO.update_check = JOJO.update_check or function(_args) return false, "update_check function not found" end -- Just in case this isn't replaced. This should ideally be replaced.
		local __, status_text = JOJO.update_check(args)
		
		if status_text == "Version up to date" or status_text == "Latest version too new" then
			mod_status[mod] = bit.bor((mod_status[mod] or 0), STATUS_FLAGS.up_to_date)
		end
		
		if status_text == "Version too new" or status_text == "Latest version too new" then
			mod_status[mod] = bit.bor((mod_status[mod] or 0), STATUS_FLAGS.too_new)
		end
		
		if status_text == "Version too old" then
			mod_status[mod] = bit.bor((mod_status[mod] or 0), STATUS_FLAGS.too_old)
		end
		
		if status_text == "There appears to have been a connection error" or status_text == "args not found" or status_text == "update_check function not found" then
			print("Connection error finding the mod details of " .. (SMODS.Mods[mod].name or "[name missing]"))
			mod_status[mod] = bit.bor((mod_status[mod] or 0), STATUS_FLAGS.err)
		end		
		
		if args.update_mandatory then
			mod_status[mod] = bit.bor((mod_status[mod] or 0), STATUS_FLAGS.necessary)
		end
	end
	
	return mod_status
end

--- Compares the current version of the specified mod and the latest version on Github, sending the update prompt
--- if the current version is outdated or too new for the modpack in question.
--- 	The pattern matching essentially reduces the version type down to a "1.2.3" or "1.2.3a" type of deal. It'section
--- a lot easier to compare that way (using V), and it even works for alpha/beta versions. Sometimes, if there are
--- connection errors, check_version() will return nil, so there has to be a null check at the start there.
JOJO.update_check = function(args, prompt)
	-- Lets args be used for all the other functions needed
	current_mod = args
	if not args then return false, "args not found" end
	
	-- Sets all the local variables properly
	update_args()
	
	local git_version = check_version()
	if not git_version then return nil, "There appears to have been a connection error" end -- This should only happen if there's been a connection error
	
	-- Sets the target version to look for
	local latest_version = git_version:match("^v?(%d+%.%d+%.%d+%a*)$")
	target_version = (not current_mod.target_version or current_mod.target_version == "-1") and latest_version or current_mod.target_version
	
	local current_version = current_mod.version:match("^v?(%d+%.%d+%.%d+%a*)$")
	
	if target_version and current_version and V(target_version) > V(current_version) then -- if the target version is newer than the current version
		if prompt then
			show_update_prompt('v' .. target_version, 'v' .. current_version)
		end
		return true, "Version too old"
	elseif target_version and current_version and V(target_version) < V(current_version) then -- if the target version is older than the current version
		if prompt then
			show_update_prompt('v' .. target_version, 'v' .. current_version)
		end
		
		if latest_version ~= target_version and V(latest_version) < V(current_version) then -- if the latest version is older than the current version
			return true, "Developer version, newer than newest version"
		elseif V(latest_version) == V(current_version) then -- if the current version is the latest version
			return true, "Latest version too new"
		end
			
		return true, "Version too new"
	end
	return true, "Version up to date"
end

--- Hooks the main menu to check for updates
local mainMenuHook = Game.main_menu
function Game:main_menu(ctx)
	local r = mainMenuHook(self, ctx)
	JOJO.update_check(SMODS.Mods[id], true)
	return r
end
local igo = Game.init_game_object
Game.init_game_object = function(self)
	local ret = igo(self)
	ret.choose_mod = 0
	return ret
end

SMODS.current_mod.optional_features = {
	retrigger_joker = true, -- Used for the Speed stat
	cardareas = { -- Used for the Kiss sticker
		discard = true,
		deck = true
	}
}

assert(SMODS.load_file("src/jokers.lua"))()
assert(SMODS.load_file("src/rarities.lua"))()
assert(SMODS.load_file("src/consumables.lua"))()
assert(SMODS.load_file("src/enhancements.lua"))()
assert(SMODS.load_file("src/stickers.lua"))()
assert(SMODS.load_file("src/atlases.lua"))()
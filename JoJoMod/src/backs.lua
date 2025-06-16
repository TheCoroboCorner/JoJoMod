SMODS.Back {
	key = "speed",
	
	atlas = 'decks',
	pos = { x = 0, y = 0 },
	
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				if not G.jokers then return false end
				SMODS.add_card({
					key = 'j_blueprint',
					edition = 'e_foil',
					stickers = {"eternal"}
				})
				SMODS.add_card({
					key = 'j_jojo_requiem_madeInHeaven',
					edition = 'e_foil',
					stickers = {"eternal"}
				})
				SMODS.add_card({
					key = 'j_jojo_requiem_madeInHeaven',
					edition = 'e_foil',
					stickers = {"eternal"}
				})
				SMODS.add_card({
					key = 'j_jojo_stand_moodyBlues',
					edition = 'e_foil',
					stickers = {"eternal"}
				})
				return true
			end
		}))
	end
}

SMODS.Back {
	key = "queensDream",
	
	atlas = 'decks',
	pos = { x = 1, y = 0 },
	
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				if not G.jokers then return false end
				SMODS.add_card({
					key = 'j_jojo_stand_harvest',
					stickers = {"eternal"}
				})
				SMODS.add_card({
					key = 'j_jojo_stand_sheerHeartAttack',
					stickers = {"eternal"}
				})
				SMODS.add_card({
					key = 'j_jojo_requiem_killerQueen',
					stickers = {"eternal"}
				})
				SMODS.add_card({
					key = 'j_jojo_stand_strayCat',
					stickers = {"eternal"}
				})
				SMODS.add_card({
					key = 'j_jojo_stand_softAndWet',
					stickers = {"eternal"}
				})
				return true
			end
		}))
	end
}

SMODS.Back {
	key = "bucciarati",
	
	atlas = 'decks',
	pos = { x = 2, y = 0 },
	
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()	
				if not G.jokers then return false end
				SMODS.add_card({
					key = 'j_jojo_stand_goldExperience'
				})
				SMODS.add_card({
					key = 'j_jojo_stand_stickyFingers'
				})
				SMODS.add_card({
					key = 'j_jojo_stand_moodyBlues'
				})
				SMODS.add_card({
					key = 'j_jojo_stand_sixPistols'
				})
				SMODS.add_card({
					key = 'j_jojo_stand_purpleHaze'
				})
				return true
			end
		}))
	end
}
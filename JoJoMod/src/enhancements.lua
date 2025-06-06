SMODS.Enhancement {
	key = 'frozen',
	config = {x_chips = 3, extra = { odds = 3 } },
	shatters = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.x_chips, 2 * G.GAME.probabilities.normal, card.ability.extra.odds } }
	end,
	
	atlas = "non-jokers",
	pos = { x = 0, y = 0},
	
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.play and context.destroy_card == card and pseudorandom('frozen') < 2 * G.GAME.probabilities.normal / card.ability.extra.odds then
			return { remove = true }
		end
	end
}
SMODS.Sticker {
	key = "kiss",
	badge_colour = HEX('c261bd'),
	
	atlas = "non-jokers",
	pos = { x = 1, y = 0 },
	
	apply = function(self, card, val)
		card.ability[self.key] = val
		if card.area then
			local copy = copy_card(card, nil, nil, card and card.playing_card and G.playing_card or nil)
			copy:add_to_deck()
			card.area:emplace(copy)
		end
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition then
			SMODS.destroy_cards(card)
		end
	end
}
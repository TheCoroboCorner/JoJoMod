shuffle = function(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

SMODS.Joker {
	key = 'stand_starPlatinum',
	config = {extra = {mult_added = 1, mult_mod = 0, chips = 0, mult = 0, 
	descP1 = 'This Stand appears to have more', descP2 = 'potential hidden deep within...'}},
	
	atlas = "stands",
	pos = { x = 0, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult_added, card.ability.extra.mult_mod,
		card.ability.extra.chips, card.ability.extra.mult,
		card.ability.extra.descP1, card.ability.extra.descP2,
		card.ability.extra.speed_added, card.ability.extra.speed}}
	end,
	
	rarity = 2,
	-- TODO: Insert atlas here
	-- TODO: Insert pos here
	cost = 7,
	blueprint_compat = true,
	
	calculate = function(self, card, context)		
		if context.first_hand_drawn and next(SMODS.find_card("j_jojo_requiem_theWorld")) then
			ease_hands_played(SMODS.find_card("j_jojo_requiem_theWorld")[1].ability.extra.hands)
		end
	
		-- Used to handle the interaction between The World and Star Platinum
		if context.ending_shop and not context.blueprint then
			if next(SMODS.find_card("j_jojo_stand_theWorld")) then
				card.ability.extra.descP1 = '\"So, The World is the same type'
				card.ability.extra.descP2 = 'of Stand as Star Platinum...\"'
				return {message = 'So, it\'s the same type of Stand as Star Platinum...', colour = G.C.DARK_EDITION}
			else
				card.ability.extra.descP1 = 'This Stand appears to have more'
				card.ability.extra.descP2 = 'potential hidden deep within...'
			end
		end
		
		-- Used to handle the time stop mechanic
		if context.modify_hand then
			if next(SMODS.find_card("j_jojo_stand_theWorld")) or next(SMODS.find_card("j_jojo_requiem_theWorld")) then -- This happens when The World is owned
				hand_chips = hand_chips + card.ability.extra.chips
				mult = mult + card.ability.extra.mult
			
				return {message = 'Tick...', colour = G.C.GOLD}
			end -- End section
		end
		
		-- Basic scoring context
		if context.joker_main then
			local l_mult_mod = nil
			local l_message = nil
			local l_colour = nil
		
			-- This happens when The World is not owned
			local playhand = G.GAME.hands[context.scoring_name].played or 0
			local bonus = true
			for k,v in pairs(G.GAME.hands) do
				if k ~= context.scoring_name and v.played >= playhand and v.visible then
					bonus = false
					break
				end
			end
			if bonus and not context.blueprint then
				card.ability.extra.mult_mod = card.ability.extra.mult_mod + card.ability.extra.mult_added
				l_mult_mod = card.ability.extra.mult_mod
				l_message = localize('k_upgrade_ex')
				l_colour = G.C.MULT
			elseif not context.blueprint then
				card.ability.extra.mult_mod = 0
				l_mult_mod = card.ability.extra.mult_mod
				l_message = localize('k_reset')
				l_colour = G.C.MULT
			elseif context.blueprint then
				l_mult_mod = card.ability.extra.mult_mod
				l_message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_mod}}
				l_colour = G.C.MULT
			end
			-- End section
			
			if next(SMODS.find_card("j_jojo_stand_theWorld")) or next(SMODS.find_card("j_jojo_requiem_theWorld")) and not context.blueprint
			and (G.GAME.current_round.hands_left == 0 or G.GAME.current_round.discards_used > 0) then -- This happens when The World is owned, with one hand left or one discard used
				card.ability.extra.chips = 0
				card.ability.extra.mult = 0
			end -- End section
			
			-- This happens when The World Over Heaven is owned
			
			-- End section
			
			return {mult_mod = l_mult_mod, message = l_message, colour = l_colour, extra = l_extra, card = l_card}
		end
		
		if context.final_scoring_step and not context.blueprint then
			if next(SMODS.find_card("j_jojo_stand_theWorld")) or next(SMODS.find_card("j_jojo_requiem_theWorld")) then
				if (G.GAME.current_round.hands_left > 0 and G.GAME.current_round.discards_used == 0) then
					local my_pos = nil
					for i = 1, #G.jokers.cards do
						if G.jokers.cards[i] == card then
							my_pos = i
							break
						end
					end
					
					if hand_chips ~= 0 or mult ~= 0 then
						card.ability.extra.chips = hand_chips
						card.ability.extra.mult = mult
					elseif my_pos and my_pos ~= 1 then
						for i = 1, my_pos - 1 do
							local key = G.jokers.cards[i].config.center.key
							if key == 'j_jojo_stand_theWorld' or key == 'j_jojo_stand_starPlatinum' or key == 'j_jojo_requiem_theWorld' then
								card.ability.extra.chips = G.jokers.cards[i].ability.extra.chips
								card.ability.extra.mult = G.jokers.cards[i].ability.extra.mult
								break
							end
						end
					end
			
					hand_chips = 0
					mult = 0
			
					return {message = 'Tick...', colour = G.C.GOLD}
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_magiciansRed',
	config = {extra = {destroyed = 0}},
	
	atlas = "stands",
	pos = { x = 1, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.destroyed}}
	end,
	
	rarity = 2,
	cost = 5,
	blueprint_compat = false,
	
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local eval = function()
				return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES
			end
			juice_card_until(card, eval, true)
		end
		if context.discard and not context.blueprint and G.GAME.current_round.discards_used <= 0 and not context.hook then
			if card.ability.extra.destroyed == 0 then
				card.ability.extra.destroyed = #context.full_hand
				G.hand:change_size(-card.ability.extra.destroyed)
			end
			return {
				remove = true
			}
		end
		if context.end_of_round then
			G.hand:change_size(card.ability.extra.destroyed)
			card.ability.extra.destroyed = 0
		end
	end	
}

SMODS.Joker {
	key = 'stand_hermitPurple',	
	config = {extra = {rank = (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.value or "Ace"),
					   suit = (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit or "Diamonds")}},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 2, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.rank,
				card.ability.extra.suit
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.hand_drawn then
			card.ability.extra.rank = (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards]:get_id() or "Ace")
			card.ability.extra.suit = (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit or "Diamonds")
		end
	end
}

SMODS.Joker {
	key = 'stand_silverChariot',
	config = {extra = {odds = 2}},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 3, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds}}
	end,
	
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local eval = function()
				return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
			end
			juice_card_until(card, eval, true)
		end
		if context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then
			if pseudorandom('silverchariot' .. G.GAME.round_resets.ante) < G.GAME.probabilities.normal / card.ability.extra.odds then
				ease_hands_played(1)
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_theWorld',	
	config = {extra = {chips = 0, mult = 0}},
	rarity = 3,
	cost = 10,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 4, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
	end,
	
	calculate = function(self, card, context)
		if (G.GAME.current_round.hands_left > 0 and G.GAME.current_round.discards_used == 0)
		and (context.final_scoring_step) and not context.blueprint then
			local my_pos = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					my_pos = i
					break
				end
			end
			
			if hand_chips ~= 0 or mult ~= 0 then
				card.ability.extra.chips = hand_chips
				card.ability.extra.mult = mult
			elseif my_pos and my_pos ~= 1 then
				for i = 1, my_pos - 1 do
					local key = G.jokers.cards[i].config.center.key
					if key == 'j_jojo_stand_theWorld' or key == 'j_jojo_stand_starPlatinum' or key == 'j_jojo_requiem_theWorld' then
						card.ability.extra.chips = G.jokers.cards[i].ability.extra.chips
						card.ability.extra.mult = G.jokers.cards[i].ability.extra.mult
						break
					end
				end
			end
			
			hand_chips = 0
			mult = 0
			
			return {message = 'Tick...', colour = G.C.GOLD}
		end
		if context.modify_hand then
			hand_chips = hand_chips + card.ability.extra.chips
			mult = mult + card.ability.extra.mult
			
			return {message = 'Tick...', colour = G.C.GOLD}
		end
		if (G.GAME.current_round.hands_left == 0 or G.GAME.current_round.discards_used > 0)
		and context.joker_main then
			card.ability.extra.chips = 0
			card.ability.extra.mult = 0
			
			return {message = 'Time has begun to move again...', colour = G.C.GOLD}
		end
	end
}

SMODS.Joker {
	key = 'stand_hangedMan',
	config = { extra = { bonusChipsGlass = 50, bonusChipsFrozen = 15 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 5, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonusChipsGlass, card.ability.extra.bonusChipsFrozen } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card)) then
			if next(SMODS.get_enhancements(context.other_card)) == "m_glass" then
				return {
					chips = card.ability.extra.bonusChipsGlass
				}
			elseif next(SMODS.get_enhancements(context.other_card)) == "m_jojo_frozen" then
				return {
					chips = card.ability.extra.bonusChipsFrozen
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_theSun',
	config = { extra = { bonusChips = 0, chipIncrement = 75, handVelocity = -1, deltaSize = 0 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 6, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chipIncrement, card.ability.extra.handVelocity, card.ability.extra.bonusChips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { chips = card.ability.extra.bonusChips }
		end
		if context.post_joker and not context.blueprint then
			card.ability.extra.bonusChips = card.ability.extra.bonusChips + card.ability.extra.chipIncrement
			G.hand:change_size(card.ability.extra.handVelocity)
			card.ability.extra.deltaSize = card.ability.extra.deltaSize + card.ability.extra.handVelocity
			return { message = localize('k_upgrade_ex'), colour = G.C.CHIPS, message_card = card }
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			G.hand:change_size(-card.ability.extra.deltaSize)
			card.ability.extra.deltaSize = 0
			card.ability.extra.bonusChips = 0
			return { message = localize('k_reset') }
		end
	end
}

SMODS.Joker {
	key = 'stand_judgement',
	rarity = 3,
	cost = 9,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 7, y = 0 },
	
	add_to_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v * 3
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v / 3
		end
	end
}

SMODS.Joker {
	key = 'stand_tohth',
	config = {extra = {reward = 2, hand = 'High Card'}},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 8, y = 0 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.reward, card.ability.extra.hand}}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.scoring_name == card.ability.extra.hand then
				return { dollars = card.ability.extra.reward }
			else
				return { dollars = -card.ability.extra.reward }
			end
		end
		
		if context.after and context.cardarea == G.play and not context.blueprint then
			local _hands = {}
			for k, v in pairs(G.GAME.hands) do
				if v.visible and k ~= card.ability.extra.hand then
					_hands[#_hands + 1] = k
				end
			end
			card.ability.extra.hand = pseudorandom_element(_hands, pseudoseed('jojo_to_do'))
			return { message = localize('k_reset') }
		end
	end,
	
	set_ability = function(self, card, initial, delay_sprites)
		if G.STATE ~= G.STATES.RUN then return nil end
		
		local _hands = {}
		for k, v in pairs(G.GAME.hands) do
			if v.visible and k ~= card.ability.extra.hand then
				_hands[#_hands + 1] = k
			end
		end
		card.ability.extra.hand = pseudorandom_element(_hands, pseudoseed((card.area and card.area.config.type == 'title') 
		and 'false' and 'true'))
	end
}

SMODS.Joker {
	key = 'stand_osiris',
	config = {extra = {currentSold = 0, requiredSold = 1}},
	rarity = 2,
	cost = 5,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 0, y = 1 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.currentSold, card.ability.extra.requiredSold}}
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.extra.currentSold = 0
			
			if G.GAME.blind.boss then
				card.ability.extra.requiredSold = math.ceil(#G.jokers.cards / 4)
				return { message = localize('k_upgrade_ex') }
			else
				card.ability.extra.requiredSold = 0
				return { message = localize('k_reset') }
			end
		end
		if (G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.boss)
		and (context.selling_card and context.card.ability.set == "Joker") then
			card.ability.extra.currentSold = (card.ability.extra.currentSold or 0) + 1
			if card.ability.extra.currentSold >= card.ability.extra.requiredSold then
				return {
					message = localize('ph_boss_disabled'),
					func = function()
						G.GAME.blind:disable()
					end
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_crazyDiamond',
	config = {},
	rarity = 3,
	cost = 10,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 1, y = 1 },
	
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	
	calculate = function(self, card, context)
	
		if context.remove_playing_cards then
			for _, removed_card in ipairs(context.removed) do
				-- Duplicate the card
				G.playing_card = (G.playing_card and G.playing_card + 1) or 1
				local copy_card = copy_card(removed_card, nil, nil, G.playing_card)
				copy_card:add_to_deck()
				G.deck.config.card_limit = G.deck.config.card_limit + 1
				table.insert(G.playing_cards, copy_card)
				G.hand:emplace(copy_card)
				copy_card.states.visible = nil

				G.E_MANAGER:add_event(Event({
					func = function()
						copy_card:start_materialize()
						return true
					end
				}))
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_theHand',
	config = {},
	rarity = 2,
	cost = 7,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 2, y = 1 },
	
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.play and #context.full_hand == 3 and not context.blueprint then
			if context.destroy_card == context.scoring_hand[2] then
				return { remove = true }
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_pearlJam',
	config = { extra = { chips = 0, mult = 0, xmult = 1, speed = 1 } },
	rarity = 2,
	cost = 3,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 3, y = 1 },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult, card.ability.extra.speed } }
	end,
	calculate = function(self, card, context)
		if context.retrigger_joker_check and context.other_card == card and not context.retrigger_joker and card.ability.extra.speed >= 2 then
			return {
				message = 'Again!',
				repetitions = math.floor(card.ability.extra.speed - 1),
				card = card
			}
		end
		if context.consumeable and not context.blueprint then
			local key = context.consumeable.config.center.key
			
			if key == 'c_jojo_harlotSpaghetti' then
				card.ability.extra.chips = card.ability.extra.chips + context.consumeable.ability.extra.chips
			elseif key == 'c_jojo_meatAppleSauce' then
				card.ability.extra.mult = card.ability.extra.mult + context.consumeable.ability.extra.mult
			elseif key == 'c_jojo_carrozza' then
				card.ability.extra.xmult = card.ability.extra.xmult + context.consumeable.ability.extra.xMult
			elseif key == 'c_jojo_doppio' then
				card.ability.extra.speed = card.ability.extra.speed + context.consumeable.ability.extra.speed
			end
		end
		if context.card_added and context.card.ability.consumeable then
			local key = context.card.config.center.key
			
			if key == 'c_jojo_water' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_refinedWater' })
			elseif key == 'c_jojo_tomatoes' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_tomatoSalad' })
			elseif key == 'c_jojo_spaghetti' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_harlotSpaghetti' })
			elseif key == 'c_jojo_meat' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_meatAppleSauce' })
			elseif key == 'c_jojo_caramel' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_flan' })
			elseif key == 'c_jojo_bread' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_bruschetta' })
			elseif key == 'c_jojo_dough' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_pizza' })
			elseif key == 'c_jojo_mozzarella' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_carrozza' })
			elseif key == 'c_jojo_ricotta' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_cannolo' })
			elseif key == 'c_jojo_beans' then
				SMODS.destroy_cards(context.card)
				SMODS.add_card({ key = 'c_jojo_doppio' })
			end
			
			return { message = localize('k_upgrade_ex') }
		end
		if context.joker_main then
			return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, xmult = card.ability.extra.xmult }
		end
		if context.after and not context.blueprint and not context.retrigger_joker and (card.ability.extra.chips > 0 or card.ability.extra.mult > 0 or card.ability.extra.xmult > 0) then
			card.ability.extra.chips = 0
			card.ability.extra.mult = 0
			card.ability.extra.xmult = 1
			return { message = localize('k_reset') }
		end
		if context.end_of_round and not context.blueprint and not context.retrigger_joker and context.game_over == false and context.main_eval and G.GAME.blind.boss and card.ability.extra.speed > 0 then
			card.ability.extra.speed = 1
			return { message = localize('k_reset') }
		end
	end
}

SMODS.Joker {
	key = 'stand_heavensDoor',
	rarity = 4,
	cost = 20,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 0, y = 6 },
	
	calculate = function(self, card, context)
		if context.card_added and context.card.ability.consumeable then
			if type(context.card.ability) == "table" then
				for key, entry in pairs(context.card.ability) do
					if type(entry) == "number" then
						context.card.ability[key] = 2 * entry
					end
				end
			elseif type(context.card.ability) == "number" then
				context.card.ability = context.card.ability * 2
			end
			if context.card.ability.extra then
				if type(context.card.ability.extra) == "table" then
					for key, entry in pairs(context.card.ability.extra) do
						if type(entry) == "number" then
							context.card.ability.extra[key] = 2 * entry
						end
					end
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_harvest',
	rarity = 2,
	cost = 5,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 4, y = 1 },
	
	calculate = function(self, card, context)
		if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			local probability = pseudorandom('harvest' .. G.GAME.round_resets.ante)
			
			if probability < 1/2 then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'jojo_Scraps',
							key_append = 'jojo_stand_harvest'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = localize('k_plus_tarot'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			elseif probability < 13/20 then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Tarot',
							key_append = 'jojo_stand_harvest'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = localize('k_plus_tarot'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			elseif probability < 4/5 then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Planet',
							key_append = 'jojo_stand_harvest'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = localize('k_plus_planet'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			elseif probability < 19/20 then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Spectral',
							key_append = 'jojo_stand_harvest'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = localize('k_plus_spectral'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			else
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'jojo_Stand',
							key_append = 'jojo_stand_harvest'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = localize('k_plus_spectral'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_atomHeartFather',
	rarity = 3,
	cost = 7,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 5, y = 1 },
	
	calculate = function(self, card, context)
		if context.consumeable and not context.blueprint then
			if context.consumeable.config.center.key == "c_jojo_standArrow" then
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Spectral',
							key = 'c_jojo_standArrow',
							key_append = 'jojo_stand_atomHeartFather',
							edition = 'e_negative'
						}
						return true
					end)
				}))
				card:start_dissolve()
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_strayCat',
	config = { extra = { readyToShoot = 0 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 6, y = 1 },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.readyToShoot } }
	end,
	calculate = function(self, card, context)
		if context.hand_drawn then
			local eval = function()
				return not context.before and card.ability.extra.readyToShoot > 0 and not G.RESET_JIGGLES
			end
			juice_card_until(card, eval, true)
		end
		if context.before and card.ability.extra.readyToShoot > 0 and G.hand.cards and not context.blueprint then
			local randomCard = pseudorandom_element(G.hand.cards, pseudoseed('strayCat' .. G.GAME.round_resets.ante))
			SMODS.destroy_cards(randomCard)
			card.ability.extra.readyToShoot = card.ability.extra.readyToShoot - 1
			return { message = "Bang!", colour = G.C.RED, message_card = card }
		end
		if context.selling_card and not context.blueprint then
			if card.ability.extra.readyToShoot == 3 then
				return { message = "Meow!!", colour = G.C.RED, message_card = card }
			end
			
			card.ability.extra.readyToShoot = math.min(card.ability.extra.readyToShoot + 1, 3)
			
			if card.ability.extra.readyToShoot >= 3 then
				return { message = "Meow!", colour = G.C.PURPLE, message_card = card }
			else
				return { message = "Meow...", colour = G.C.PURPLE, message_card = card }
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_sheerHeartAttack',
	config = {extra = {rank = '7'}},
	rarity = 3,
	cost = 9,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 7, y = 1 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {localize(card.ability.extra.rank, 'ranks'), card.ability.extra.rank}}
	end,
	
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.play and not context.blueprint then
			if context.destroy_card.base.value == card.ability.extra.rank then
				return { remove = true }
			else
				return { remove = false }
			end
		end
		
		if context.end_of_round then
			local valid_cards = {}
			for _, card in ipairs(G.playing_cards) do
				if not SMODS.has_no_suit(card) and not SMODS.has_no_rank(card) then
					valid_cards[#valid_cards + 1] = card
				end
			end
			
			local stand_card = pseudorandom_element(valid_cards, pseudoseed('sheerHeartAttack' .. G.GAME.round_resets.ante))
			if stand_card then
				card.ability.extra.rank = stand_card.base.value
			end
		end
	end,
	
	set_ability = function(self, card, initial, delay_sprites)
		if G.STATE ~= G.STATES.RUN then return nil end
		
		local valid_cards = {}
		for _, card in ipairs(G.playing_cards) do
			if not SMODS.has_no_suit(card) and not SMODS.has_no_rank(card) then
				valid_cards[#valid_cards + 1] = card
			end
		end
			
		local stand_card = pseudorandom_element(valid_cards, pseudoseed('sheerHeartAttack' .. G.GAME.round_resets.ante))
		if stand_card then
			card.ability.extra.rank = stand_card.base.value
		end
	end
}

SMODS.Joker {
	key = 'stand_killerQueen',
	config = {extra = {reward = 3}},
	rarity = 2,
	cost = 5,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 8, y = 1 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.reward}}
	end,
	
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local eval = function() 
				return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
			end
			juice_card_until(card, eval, true)
		end
		if context.destroy_card and not context.blueprint then
			if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and G.GAME.current_round.hands_played == 0 then
				return { remove = true }
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_goldExperience',
	config = {extra = {odds = 4}},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 0, y = 2 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds}}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and context.other_card:is_face() then
			if pseudorandom('goldexperience' .. G.GAME.round_resets.ante) < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Tarot',
							key_append = 'jojo_stand_goldExperience'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = localize('k_plus_tarot'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_stickyFingers',
	config = {extra = {selectionLimit = 1}},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 1, y = 2 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.selectionLimit}}
	end,
	
	add_to_deck = function(self, card, from_debuff)
		G.GAME.choose_mod = (G.GAME.choose_mod or 0) + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.choose_mod = (G.GAME.choose_mod or 1) - 1
	end,
	
	calculate = function(self, card, context)
		
	end
}

SMODS.Joker {
	key = 'stand_blackSabbath',
	rarity = 3,
	cost = 7,
	
	atlas = "stands",
	pos = { x = 2, y = 2 },
}

SMODS.Joker {
	key = 'stand_moodyBlues',
	config = {},
	rarity = 3,
	cost = 10,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 3, y = 2 },
	
	loc_vars = function(self, info_queue, card)
		if card.area and card.area == G.jokers then
			local other_joker
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					other_joker = G.jokers.cards[i - 1]
				end
			end
			local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
			main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
							}
						}
					}
				}
			}
			return { main_end = main_end }
		end
	end,
	
	calculate = function(self, card, context)
		local other_joker = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				other_joker = G.jokers.cards[i - 1]
			end
		end
		return SMODS.blueprint_effect(card, other_joker, context)
	end
}

SMODS.Joker {
	key = 'stand_sixPistols',
	config = {extra = {bulletCount = 0}},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 4, y = 2 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.bulletCount}}
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind then
			if card.ability.extra.bulletCount >= 6 then
				return nil
			end
			return {
				func = function()
					G.E_MANAGER:add_event(Event({
						func = (function()
							G.E_MANAGER:add_event(Event({
								func = function()
									SMODS.add_card {
										key = 'c_jojo_bullet',
										edition = 'e_negative',
										key_append = 'jojo_sixPistols'
									}
									return true
								end
							}))
							SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.MONEY },
								context.blueprint_card or card)
							return true
						end)
					}))
					card.ability.extra.bulletCount = card.ability.extra.bulletCount + 1
					if card.ability.extra.bulletCount >= 6 then
						card:start_dissolve()
					end
				end
			}
		end
	end
}

SMODS.Joker {
	key = 'stand_purpleHaze',
	config = { extra = { incrXmult = 0.1, xmult = 1 } },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 5, y = 2 },
	
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.incrXmult, card.ability.extra.xmult} }
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local my_pos = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					my_pos = i
					break
				end
			end
			
			local lCard = my_pos and G.jokers.cards[my_pos - 1]
			local rCard = my_pos and G.jokers.cards[my_pos + 1]
			if lCard and not lCard.ability.eternal and not lCard.getting_sliced then
				local sliced_card = lCard
				sliced_card.getting_sliced = true
				G.GAME.joker_buffer = G.GAME.joker_buffer - 1
				G.E_MANAGER:add_event(Event({
					func = function()
						G.GAME.joker_buffer = 0
						card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.incrXmult
						card:juice_up(0.8, 0.8)
						sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
						play_sound('slice1', 0.96 + math.random() * 0.08)
						return true
					end
				}))
			end
			if rCard and not rCard.ability.eternal and not rCard.getting_sliced then
				local sliced_card = rCard
				sliced_card.getting_sliced = true
				G.GAME.joker_buffer = G.GAME.joker_buffer - 1
				G.E_MANAGER:add_event(Event({
					func = function()
						G.GAME.joker_buffer = 0
						card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.incrXmult
						card:juice_up(0.8, 0.8)
						sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
						play_sound('slice1', 0.96 + math.random() * 0.08)
						return true
					end
				}))
			end
			
			local incrementCount = (lCard and 1 or 0) + (rCard and 1 or 0)
			if incrementCount then
				return {
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult + incrementCount * card.ability.extra.incrXmult } },
					colour = G.C.RED,
					no_juice = true
				}
			end
		end
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end
}

SMODS.Joker {
	key = 'stand_mrPresident',
	config = {extra = {consumableSlots = 1}},
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 6, y = 2 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.consumableSlots}}
	end,
	
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.consumableSlots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.consumableSlots
	end,
	calculate = function(self, card, context)
	
	end
}

SMODS.Joker {
	key = 'stand_theGratefulDead',
	config = { extra = { ageUpAmount = 1 } },
	rarity = 3,
	cost = 8,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 7, y = 2 },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.ageUpAmount } }
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn and not context.blueprint and G.hand.cards then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					play_sound('tarot1')
					card:juice_up(0.3, 0.5)
					return true
				end
			}))
			for i = 1, #G.hand.cards do
				local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
						return true
					end
				}))
			end
			local dead = {}
			local alive = {}
			for i = 1, #G.hand.cards do
				if G.hand.cards[i]:get_id() == 14 - card.ability.extra.ageUpAmount and not (next(SMODS.get_enhancements(G.hand.cards[i])) and next(SMODS.get_enhancements(G.hand.cards[i])) == 'm_jojo_frozen') then
					dead[#dead + 1] = G.hand.cards[i]
				else
					alive[#alive + 1] = G.hand.cards[i]
				end
			end
			if dead then
				for i = 1, #dead do
					SMODS.destroy_cards(dead[i])
				end
				-- SMODS.destroy_cards(dead)
			end
			for i = 1, #alive do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						if not (next(SMODS.get_enhancements(alive[i])) and next(SMODS.get_enhancements(alive[i])) == 'm_jojo_frozen') then
							assert(SMODS.modify_rank(alive[i], card.ability.extra.ageUpAmount))
						end
						return true
					end
				}))
			end
			for i = 1, #alive do
				local percent = 0.85 + (i - 0.999) / (#alive - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
						return true
					end
				}))
			end
		end
	end
}

SMODS.Joker {
	key = 'stand_whiteAlbum',
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 8, y = 2 },
	
	calculate = function(self, card, context)
		if context.before and context.main_eval then
			local randomCard = pseudorandom_element(context.scoring_hand, pseudoseed('whiteAlbum' .. G.GAME.round_resets.ante))
			
			randomCard:set_ability("m_jojo_frozen")
		end
	end
}

SMODS.Joker {
	key = 'stand_kiss',
	config = { extra = { odds = 3 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 0, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if context.consumeable and not context.consumeable.ability['jojo_kiss'] and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			if pseudorandom('kiss' .. G.GAME.round_resets.ante) < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							key = 'c_jojo_kiss',
							key_append = 'jojo_stand_kiss'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = "Mwah!",
					colour = G.C.SECONDARY_SET.Tarot
				}
			end
		end
	end
	
}

SMODS.Joker {
	key = 'stand_whitesnake',
	config = {extra = {chips = 0, plusmult = 0, timesmult = 1}},
	rarity = 3,
	cost = 12,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 1, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips, card.ability.extra.plusmult, card.ability.extra.timesmult}}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.plusmult,
				xmult = card.ability.extra.timesmult
			}
		end
		if context.remove_playing_cards and not context.blueprint then
			for _, removed_card in ipairs(context.removed) do
				if removed_card.edition then
					if removed_card.edition.key == 'e_foil' then
						card.ability.extra.chips = card.ability.extra.chips + 50
					elseif removed_card.edition.key == 'e_holo' then
						card.ability.extra.plusmult = card.ability.extra.plusmult + 10
					elseif removed_card.edition.key == 'e_polychrome' then
						card.ability.extra.timesmult = card.ability.extra.timesmult + 1.5
					end
				end
			end
			return { message = localize('k_upgrade_ex') }
		end
	end
}

SMODS.Joker {
	key = 'stand_dragonsDream',
	config = {extra = {reward = 4, luckyHand = 'Ace', unluckyHand = '5'}},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 2, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.reward, card.ability.extra.luckyHand, card.ability.extra.unluckyHand}}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == card.ability.extra.luckyHand then
				return { dollars = card.ability.extra.reward }
			end
			if context.other_card.base.value == card.ability.extra.unluckyHand then
				return { dollars = -card.ability.extra.reward }
			end
		end
		
		if context.end_of_round and not context.blueprint then
			local valid_cards = {}
			for _, card in ipairs(G.playing_cards) do
				if not SMODS.has_no_suit(card) and not SMODS.has_no_rank(card) then
					local rankNotInValidCards = true
					for i, v in ipairs(valid_cards) do
						if v.base.value == card.base.value then
							rankNotInValidCards = false
						end
					end
					
					if rankNotInValidCards then
						valid_cards[#valid_cards + 1] = card
					end
				end
			end
			
			local lucky_card = pseudorandom_element(valid_cards, pseudoseed('dragonsDreamLucky' .. G.GAME.round_resets.ante))
			if lucky_card then
				card.ability.extra.luckyHand = lucky_card.base.value
			end
			valid_cards[lucky_card] = nil
			local unlucky_card = pseudorandom_element(valid_cards, pseudoseed('dragonsDreamUnlucky' .. G.GAME.round_resets.ante))
			if unlucky_card then
				card.ability.extra.unluckyHand = unlucky_card.base.value
			else
				card.ability.extra.unluckyHand = card.ability.extra.luckyHand
			end
		end
	end,
	
	set_ability = function(self, card, initial, delay_sprites)
		if G.STATE ~= G.STATES.RUN then return nil end
		
		local valid_cards = {}
		for _, card in ipairs(G.playing_cards) do
			if not SMODS.has_no_suit(card) and not SMODS.has_no_rank(card) then
				valid_cards[#valid_cards + 1] = card
			end
		end
			
		local lucky_card = pseudorandom_element(valid_cards, pseudoseed('dragonsDreamLucky' .. G.GAME.round_resets.ante))
		if lucky_card then
			card.ability.extra.luckyHand = lucky_card.base.value
		end
		valid_cards[lucky_card] = nil
		local unlucky_card = pseudorandom_element(valid_cards, pseudoseed('dragonsDreamUnlucky' .. G.GAME.round_resets.ante))
		if unlucky_card then
			card.ability.extra.unluckyHand = unlucky_card.base.value
		end
	end
}

SMODS.Joker {
	key = 'stand_tuskAct1',
	config = {extra = {incrXmult = 0.2, totalXmult = 1}},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 3, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.incrXmult, card.ability.extra.totalXmult}}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.totalXmult }
		end
		if context.failed_wheel and not context.blueprint then
			card.ability.extra.totalXmult = card.ability.extra.totalXmult + card.ability.extra.incrXmult
			return { message = localize('k_upgrade_ex') }
		end
	end
}

SMODS.Joker {
	key = 'stand_softAndWet',
	config = {},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 4, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind then
			return {
				func = function()
					G.E_MANAGER:add_event(Event({
						func = (function()
							G.E_MANAGER:add_event(Event({
								func = function()
									SMODS.add_card {
										key = 'c_jojo_bubble',
										edition = 'e_negative',
										key_append = 'jojo_softAndWet'
									}
									return true
								end
							}))
							SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.MONEY },
								context.blueprint_card or card)
							return true
						end)
					}))
				end
			}
		end
	end
}

SMODS.Joker {
	key = 'stand_theMattekudasai',
	config = {extra = {rank = '7'}},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 5, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.rank}}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == card.ability.extra.rank and (G.consumeables.cards and #G.consumeables.cards or 1) + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card { key = "c_death" }
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				return {
					message = localize('k_plus_tarot'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			end
		end
		if context.end_of_round and not context.blueprint then
			local valid_cards = {}
			for _, card in ipairs(G.playing_cards) do
				if not SMODS.has_no_suit(card) and not SMODS.has_no_rank(card) then
					valid_cards[#valid_cards + 1] = card
				end
			end
			
			local stand_card = pseudorandom_element(valid_cards, pseudoseed('theMattekudasai' .. G.GAME.round_resets.ante))
			if stand_card then
				card.ability.extra.rank = stand_card.base.value
			end
		end
	end,
	
	set_ability = function(self, card, initial, delay_sprites)
		if G.STATE ~= G.STATES.RUN then return nil end
		
		local valid_cards = {}
		for _, card in ipairs(G.playing_cards) do
			if not SMODS.has_no_suit(card) and not SMODS.has_no_rank(card) then
				valid_cards[#valid_cards + 1] = card
			end
		end
			
		local stand_card = pseudorandom_element(valid_cards, pseudoseed('theMattekudasai' .. G.GAME.round_resets.ante))
		if stand_card then
			card.ability.extra.rank = stand_card.base.value
		end
	end
}

SMODS.Joker {
	key = 'stand_bigmouthStrikesAgain',
	config = {extra = {jokerSlots = 1}},
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 6, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.jokerSlots}}
	end,
	
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.jokerSlots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.jokerSlots
	end,
	calculate = function(self, card, context)
		
	end
}

SMODS.Joker {
	key = 'requiem_silverChariot',
	config = {extra = {odds = 2}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 7, y = 3 },
	soul_pos = { x = 8, y = 3 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds}}
	end,
	
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			local enhancements = {}
			local editions = {}
			local seals = {}
			
			for _, scored_card in ipairs(context.scoring_hand) do
				if next(SMODS.get_enhancements(scored_card)) then
					enhancements[#enhancements + 1] = next(SMODS.get_enhancements(scored_card))
					scored_card:set_ability(G.P_CENTERS.c_base, true, nil)
				end
				if scored_card.edition then
					editions[#editions + 1] = scored_card.edition.key
					scored_card:set_edition(nil, true)
				end
				if scored_card.seal then
					seals[#seals + 1] = scored_card.seal
					scored_card:set_seal(nil, true)
				end
			end
			
			for _, scored_card in ipairs(context.scoring_hand) do
				G.E_MANAGER:add_event(Event({
					func = function()
						scored_card:juice_up()
						return true
					end
				}))
			end
				
			
			local attempt = pseudorandom('silverchariotrequiem' .. G.GAME.round_resets.ante)
			local chance = G.GAME.probabilities.normal / card.ability.extra.odds
			if attempt < chance then
				if attempt < 1/3 * chance and #enhancements < #context.scoring_hand then
					enhancements[#enhancements + 1] = SMODS.poll_enhancement({ guaranteed = true })
				elseif attempt < 2/3 * chance and #editions < #context.scoring_hand then
					local probability = pseudorandom('silverchariotrequiemedition' .. G.GAME.round_resets.ante)
					local edition = nil
					
					if probability < 19/40 then
						edition = "e_foil"
					elseif probability < 323/400 then
						edition = "e_holo"
					elseif probability < 31/32 then
						edition = "e_polychrome"
					else
						edition = "e_negative"
					end
					
					editions[#editions + 1] = edition
				elseif #seals < #context.scoring_hand then
					seals[#seals + 1] = SMODS.poll_seal({ guaranteed = true })
				end
			end
			
			local shuffledCards = {}
			for i, t in ipairs(context.scoring_hand) do
				shuffledCards[i] = t
			end
			
			shuffle(shuffledCards)
			for i, enhancement in ipairs(enhancements) do
				shuffledCards[i]:set_ability(enhancement)
			end
			
			shuffle(shuffledCards)
			for i, edition in ipairs(editions) do
				shuffledCards[i]:set_edition(edition)
			end
			
			shuffle(shuffledCards)
			for i, seal in ipairs(seals) do
				shuffledCards[i]:set_seal(seal)
			end
			
			for _, scored_card in ipairs(context.scoring_hand) do
				G.E_MANAGER:add_event(Event({
					func = function()
						scored_card:juice_up()
						return true
					end
				}))
			end
		end
	end
}

SMODS.Joker {
	key = 'requiem_theWorld',
	config = {extra = {hands = 3, chips = 0, mult = 0}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 0, y = 4 },
	soul_pos = { x = 1, y = 4 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.hands, card.ability.extra.chips, card.ability.extra.mult}}
	end,
	
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			ease_hands_played(card.ability.extra.hands)
		end
		if (G.GAME.current_round.hands_left > 0 and G.GAME.current_round.discards_used == 0)
		and (context.final_scoring_step) and not context.blueprint then
			local my_pos = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					my_pos = i
					break
				end
			end
			
			if hand_chips ~= 0 or mult ~= 0 then
				card.ability.extra.chips = hand_chips
				card.ability.extra.mult = mult
			elseif my_pos and my_pos ~= 1 then
				for i = 1, my_pos - 1 do
					local key = G.jokers.cards[i].config.center.key
					if key == 'j_jojo_stand_theWorld' or key == 'j_jojo_stand_starPlatinum' or key == 'j_jojo_requiem_theWorld' then
						card.ability.extra.chips = G.jokers.cards[i].ability.extra.chips
						card.ability.extra.mult = G.jokers.cards[i].ability.extra.mult
						break
					end
				end
			end
			
			hand_chips = 0
			mult = 0
			
			return {message = 'Tick...', colour = G.C.GOLD}
		end
		if context.modify_hand then
			hand_chips = hand_chips + card.ability.extra.chips
			mult = mult + card.ability.extra.mult
			
			return {message = 'Tick...', colour = G.C.GOLD}
		end
		if (G.GAME.current_round.hands_left == 0 or G.GAME.current_round.discards_used > 0)
		and context.joker_main and not context.blueprint then
			card.ability.extra.chips = 0
			card.ability.extra.mult = 0
			
			return {message = 'Time has begun to move again...', colour = G.C.GOLD}
		end
	end
}

SMODS.Joker {
	key = 'requiem_killerQueen',
	config = {extra = {reward = 3}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = false,
	
	atlas = "stands",
	pos = { x = 2, y = 4 },
	soul_pos = { x = 3, y = 4 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.reward}}
	end,
	
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			if scoring_hand then -- if it's a played hand
				ease_hands_played(1)
			else -- if it's a discarded hand
				ease_discard(1)
			end
		end
		if context.first_hand_drawn then
			local eval = function() 
				return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
			end
			juice_card_until(card, eval, true)
		end
		if context.destroy_card and not context.blueprint then
			if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and G.GAME.current_round.hands_played == 0 then
				return { remove = true }
			end
		end
	end
}

SMODS.Joker {
	key = 'requiem_goldExperience',
	config = {extra = {discards = 3, odds = 4}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 4, y = 4 },
	soul_pos = { x = 5, y = 4 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.discards}}
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind then
			ease_discard(card.ability.extra.discards)
		end
		if context.individual and context.cardarea == G.play and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and context.other_card:is_face() then
			if pseudorandom('goldexperiencerequiem' .. G.GAME.round_resets.ante) < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Tarot',
							key_append = 'jojo_requiem_goldExperience'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				
				return {
					message = localize('k_plus_tarot'),
					colour = G.C.SECONDARY_SET.Tarot
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'requiem_cmoon',
	config = {extra = {chips = 0, plusmult = 0, timesmult = 1}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 6, y = 4 },
	soul_pos = { x = 7, y = 4 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips, card.ability.extra.plusmult, card.ability.extra.timesmult}}
	end,
	
	calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
			local this_joker = nil
			for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] == card then
						this_joker = i
					break
				end
			end
			
			if not this_joker then return nil end
			
			if (context.other_card == G.jokers.cards[this_joker - 1]) or (context.other_card == G.jokers.cards[this_joker + 1]) then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			else
				return nil, true
			end
		end
		
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.plusmult,
				xmult = card.ability.extra.timesmult
			}
		end
	end
}

SMODS.Joker {
	key = 'requiem_madeInHeaven',
	config = {extra = {chips = 0, plusmult = 0, timesmult = 1, timesspeed = 1, speedincrement = 0.25}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 8, y = 4 },
	soul_pos = { x = 0, y = 5 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips, card.ability.extra.plusmult, card.ability.extra.timesmult, card.ability.extra.timesspeed, card.ability.extra.speedincrement}}
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind and not context.retrigger_joker and not context.blueprint then
			card.ability.extra.timesspeed = card.ability.extra.timesspeed + card.ability.extra.speedincrement
			return { message = localize('k_upgrade_ex'), colour = G.C.GREEN, message_card = card }
		end
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
			local this_joker = nil
			for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] == card then
						this_joker = i
					break
				end
			end
			
			if not this_joker then return nil end
			
			if (context.other_card == G.jokers.cards[this_joker - 1]) or (context.other_card == G.jokers.cards[this_joker + 1]) then
				return {
					message = localize('k_again_ex'),
					repetitions = math.floor(card.ability.extra.timesspeed),
					card = card
				}
			else
				return nil, true
			end
		end
		
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.plusmult,
				xmult = card.ability.extra.timesmult
			}
		end
	end
}

SMODS.Joker {
	key = 'requiem_tuskAct2',
	config = {extra = {incrXmult = 0.2, totalXmult = 1}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 1, y = 5 },
	soul_pos = { x = 2, y = 5 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.incrXmult, card.ability.extra.totalXmult}}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.totalXmult }
		end
		if context.failed_wheel and not context.blueprint then
			card.ability.extra.totalXmult = card.ability.extra.totalXmult + card.ability.extra.incrXmult
			return { message = localize('k_upgrade_ex') }
		end
	end
}

SMODS.Joker {
	key = 'requiem_tuskAct3',
	config = {extra = {incrXmult = 0.2, totalXmult = 1}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 3, y = 5 },
	soul_pos = { x = 4, y = 5 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.incrXmult, card.ability.extra.totalXmult}}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.totalXmult }
		end
		if context.failed_wheel and not context.blueprint then
			card.ability.extra.totalXmult = card.ability.extra.totalXmult + card.ability.extra.incrXmult
			return { message = localize('k_upgrade_ex') }
		end
	end
}

SMODS.Joker {
	key = 'requiem_tuskAct4',
	config = {extra = {incrXmult = 0.2, totalXmult = 1, negativeBonus = 2}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 5, y = 5 },
	soul_pos = { x = 6, y = 5 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.negativeBonus, card.ability.extra.totalXmult}}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.totalXmult }
		end
		if context.failed_wheel and not context.blueprint then
			card.ability.extra.totalXmult = card.ability.extra.totalXmult + card.ability.extra.incrXmult
			return { message = localize('k_upgrade_ex') }
		end
		if context.other_joker and context.other_joker.edition and context.other_joker.edition.key == 'e_negative' then
			return {
				x_chips = card.ability.extra.negativeBonus
			}
		end
	end
}

SMODS.Joker {
	key = 'requiem_softAndWet',
	config = {extra = {}},
	rarity = "jojo_requiem",
	cost = 50,
	blueprint_compat = true,
	
	atlas = "stands",
	pos = { x = 7, y = 5 },
	soul_pos = { x = 8, y = 5 },
	
	loc_vars = function(self, info_queue, card)
		return {vars = {}}
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind then
			return {
				func = function()
					G.E_MANAGER:add_event(Event({
						func = (function()
							G.E_MANAGER:add_event(Event({
								func = function()
									SMODS.add_card {
										key = 'c_jojo_spinningBubble',
										edition = 'e_negative',
										key_append = 'jojo_softAndWetGoBeyond'
									}
									return true
								end
							}))
							SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.MONEY },
								context.blueprint_card or card)
							return true
						end)
					}))
				end
			}
		end
	end
}
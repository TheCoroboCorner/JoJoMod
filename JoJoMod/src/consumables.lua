bezier_tweening = function(t) -- 0 < t < 1
		local a_0 = 1.91692228E-5
		local a_1 = 3.02935436
		local a_2 = -3.23506095
		local a_3 = 1.52717436
		local a_4 = -0.466669239
		local a_5 = 0.145185219
		
		return a_0 + a_1 * t + a_2 * t^2 + a_3 * t^3 + a_4 * t^4 + a_5 * t^5		
end

SMODS.ConsumableType {
	key = 'jojo_Scraps',
	default = 'c_jojo_water',
	collection_rows = { 4, 3 },
	primary_colour = HEX('b5b5b5'),
	secondary_colour = HEX('828282'),
	shop_rate = 3
}

SMODS.ConsumableType {
	key = 'jojo_Stand',
	default = 'c_jojo_bullet',
	collection_rows = { 4, 3 },
	primary_colour = HEX('f0b11f'),
	secondary_colour = HEX('cf981b')
}

SMODS.Consumable:take_ownership('wheel_of_fortune', 
	{
		config = { extra = { odds = 4 } },
		loc_vars = function(self, info_queue, card)
			return { vars = { G.GAME.probabilities.normal, card.ability.extra.odds } }
		end,
		use = function(self, card, area, copier)
			local loopCount = (next(SMODS.find_card("j_jojo_requiem_tuskAct4")) and 3)
			or ((next(SMODS.find_card("j_jojo_requiem_tuskAct3")) or next(SMODS.find_card("j_jojo_requiem_tuskAct2"))) and 2)
			or 1
			
			for i = 1, loopCount do
				if pseudorandom('wheel_of_fortune') < G.GAME.probabilities.normal / card.ability.extra.odds then
					if next(SMODS.find_card("j_jojo_requiem_tuskAct2")) or next(SMODS.find_card("j_jojo_requiem_tuskAct3")) or next(SMODS.find_card("j_jojo_requiem_tuskAct4")) then
						local jokers = G.jokers.cards					
						local joker = pseudorandom_element(jokers, pseudoseed("wheel_of_fortune"))
						
						local random = pseudorandom('you_win')
						local edition = nil
						
						if not next(SMODS.find_card("j_jojo_requiem_tuskAct3")) and not next(SMODS.find_card("j_jojo_requiem_tuskAct4")) then
							if not joker.edition then
								if random < 1/2 then
									edition = 'e_foil'
								elseif random < 17/20 then
									edition = 'e_holo'
								else
									edition = 'e_polychrome'
								end
							elseif joker.edition.key == 'e_foil' then
								if random < 57/100 then
									edition = 'e_holo'
								else
									edition = 'e_polychrome'
								end
							elseif joker.edition.key == 'e_holo' then
								edition = 'e_polychrome'
							end
						else
							if not joker.edition then
								if random < 1/2 then
									edition = 'e_foil'
								elseif random < 17/20 then
									edition = 'e_holo'
								else
									edition = 'e_polychrome'
								end
							elseif joker.edition.key == 'e_foil' then
								if random < 1/2 then
									edition = 'e_holo'
								elseif random < 17/20 then
									edition = 'e_polychrome'
								else
									edition = 'e_negative'
								end
							elseif joker.edition.key == 'e_holo' then
								if random < 57/100 then
									edition = 'e_polychrome'
								else
									edition = 'e_negative'
								end
							elseif joker.edition.key == 'e_polychrome' then
								edition = 'e_negative'
							end
						end
						
						if edition == 'e_foil' then
							joker:set_edition({foil = true}, true)
						elseif edition == 'e_holo' then
							joker:set_edition({holo = true}, true)
						elseif edition == 'e_polychrome' then
							joker:set_edition({polychrome = true}, true)
						elseif edition == 'e_negative' then
							joker:set_edition({negative = true}, true)
						end
						
						check_for_unlock({ type = 'have_edition' })
					else
						local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
						
						local eligible_card = pseudorandom_element(editionless_jokers, pseudoseed("wheel_of_fortune"))
						local edition = poll_edition('wheel_of_fortune', nil, true, true,
							{ 'e_polychrome', 'e_holo', 'e_foil' })
						eligible_card:set_edition(edition, true)
						check_for_unlock({ type = 'have_edition' })
					end
				else
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.4,
						func = function()
							attention_text({
								text = localize('k_nope_ex'),
								scale = 1.3,
								hold = 1.4,
								major = card,
								backdrop_colour = G.C.SECONDARY_SET.Tarot,
								align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
									'tm' or 'cm',
								offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
								silent = true
							})
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.06 * G.SETTINGS.GAMESPEED,
								blockable = false,
								blocking = false,
								func = function()
									play_sound('tarot2', 0.76, 0.4)
									return true
								end
							}))
							play_sound('tarot2', 1, 0.4)
							card:juice_up(0.3, 0.5)
							return true
						end
					}))
					SMODS.calculate_context({failed_wheel = true})
				end
			end
		end,
		can_use = function(self, card)
			return next(SMODS.find_card("j_jojo_requiem_tuskAct2")) or next(SMODS.find_card("j_jojo_requiem_tuskAct3")) or next(SMODS.find_card("j_jojo_requiem_tuskAct4")) or next(SMODS.Edition:get_edition_cards(G.jokers, true))
		end
	},
	true
)

--------------------------------------------------------------------------------------------------- Start of the Spectrals

SMODS.Consumable {
	key = 'standArrow',
	set = 'Spectral',
	config = { max_highlighted = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted } }
	end,
	hidden = true,
	soul_rate = 0.02,
	can_repeat_soul = true,
	soul_set = 'Tarot',
	
	atlas = 'items',
	pos = { x = 4, y = 4 },	
	soul_pos = { x = 5, y = 4 },
	
	use = function(self, card, area, copier)
		local key = G.jokers.highlighted[1].config.center.key
		
		local blackSabbathBoost = nil
		local blackSabbath = SMODS.find_card('j_jojo_stand_blackSabbath')
		
		if next(blackSabbath) then
			blackSabbathBoost = 'e_negative'
			blackSabbath[1]:start_dissolve()
		end
		
		if key == 'j_jojo_stand_silverChariot' then
			local stand = SMODS.add_card({ key = 'j_jojo_requiem_silverChariot', edition = blackSabbathBoost })
		end
		if key == 'j_jojo_stand_theWorld' then
			SMODS.add_card({ key = 'j_jojo_requiem_theWorld', edition = blackSabbathBoost })
		end
		if key == 'j_jojo_stand_killerQueen' then
			local stand = SMODS.add_card({ key = 'j_jojo_requiem_killerQueen', edition = blackSabbathBoost })
			stand.ability.extra.reward = G.jokers.highlighted[1].ability.extra.reward
		end
		if key == 'j_jojo_stand_goldExperience' then
			SMODS.add_card({ key = 'j_jojo_requiem_goldExperience', edition = blackSabbathBoost })
		end
		if key == 'j_jojo_stand_whitesnake' then
			local stand = SMODS.add_card({ key = 'j_jojo_requiem_cmoon', edition = blackSabbathBoost })
			stand.ability.extra.chips = G.jokers.highlighted[1].ability.extra.chips
			stand.ability.extra.plusmult = G.jokers.highlighted[1].ability.extra.plusmult
			stand.ability.extra.timesmult = G.jokers.highlighted[1].ability.extra.timesmult
		end
		if key == 'j_jojo_requiem_cmoon' then
			local stand = SMODS.add_card({ key = 'j_jojo_requiem_madeInHeaven', edition = blackSabbathBoost })
			stand.ability.extra.chips = G.jokers.highlighted[1].ability.extra.chips
			stand.ability.extra.plusmult = G.jokers.highlighted[1].ability.extra.plusmult
			stand.ability.extra.timesmult = G.jokers.highlighted[1].ability.extra.timesmult
		end
		if key == 'j_jojo_stand_tuskAct1' then
			SMODS.add_card({ key = 'j_jojo_requiem_tuskAct2', edition = blackSabbathBoost })
		end
		if key == 'j_jojo_requiem_tuskAct2' then
			SMODS.add_card({ key = 'j_jojo_requiem_tuskAct3', edition = blackSabbathBoost })
		end
		if key == 'j_jojo_requiem_tuskAct3' then
			SMODS.add_card({ key = 'j_jojo_requiem_tuskAct4', edition = blackSabbathBoost })
		end
		if key == 'j_jojo_stand_softAndWet' then
			SMODS.add_card({ key = 'j_jojo_requiem_softAndWet', edition = blackSabbathBoost })
		end
		
		G.jokers.highlighted[1]:start_dissolve()
	end,
	
	can_use = function(self, card)
		local validTargets = {'j_jojo_stand_silverChariot', 'j_jojo_stand_theWorld',
			'j_jojo_stand_killerQueen', 'j_jojo_stand_goldExperience', 'j_jojo_stand_whitesnake',
			'j_jojo_requiem_cmoon', 'j_jojo_stand_tuskAct1', 'j_jojo_requiem_tuskAct2',
			'j_jojo_requiem_tuskAct3', 'j_jojo_stand_softAndWet'}
		
		for _, v in ipairs(validTargets) do
			if G.jokers and G.jokers.highlighted and G.jokers.highlighted[1] and G.jokers.highlighted[1].config.center.key == v then
				return true
			end
		end
		return false
	end
}

--------------------------------------------------------------------------------------------------- End of the Spectrals

--------------------------------------------------------------------------------------------------- Start of the Stand Summons

SMODS.Consumable {
	key = 'bullet',
	set = 'jojo_Stand',
	config = { max_highlighted = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted } }
	end,
	
	atlas = 'items',
	pos = { x = 2, y = 2 },	
	
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				SMODS.destroy_cards(G.hand.highlighted)
				return true
			end
		}))
		delay(0.3)
	end
}

SMODS.Consumable {
	key = 'bubble',
	set = 'jojo_Stand',
	config = { max_highlighted = 2, min_highlighted = 2 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted } }
	end,
	
	atlas = 'items',
	pos = { x = 3, y = 2 },	

	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        local rightmost = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x > rightmost.T.x then
                rightmost = G.hand.highlighted[i]
            end
        end
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if G.hand.highlighted[i] ~= rightmost then
						if next(SMODS.get_enhancements(rightmost)) then
							G.hand.highlighted[i]:set_ability(next(SMODS.get_enhancements(rightmost)))
						end
                    end
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
	key = 'spinningBubble',
	set = 'jojo_Stand',
	config = { max_highlighted = 2, min_highlighted = 2 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted } }
	end,
	
	atlas = 'items',
	pos = { x = 4, y = 2 },	

	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        local rightmost = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x > rightmost.T.x then
                rightmost = G.hand.highlighted[i]
            end
        end
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if G.hand.highlighted[i] ~= rightmost then
						if next(SMODS.get_enhancements(rightmost)) then
							G.hand.highlighted[i]:set_ability(next(SMODS.get_enhancements(rightmost)))
						end
						if rightmost.edition then
							G.hand.highlighted[i]:set_edition(rightmost.edition.key)
						end
						if rightmost.seal then
							G.hand.highlighted[i]:set_seal(rightmost.seal)
						end
                    end
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
	key = 'kiss',
	set = 'jojo_Stand',
	
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.highlighted_limit = G.consumeables.config.highlighted_limit + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.highlighted_limit = math.max(G.consumeables.config.highlighted_limit - 1, 1)
	end,
	
	atlas = 'items',
	pos = { x = 5, y = 2 },	

	
	use = function(self, card, area, copier)
		if #G.consumeables.highlighted == 1 then
			SMODS.Stickers["jojo_kiss"]:apply(G.consumeables.highlighted[1], true)
--			SMODS.Stickers["eternal"]:apply(G.consumeables.highlighted[1], true)
		elseif #G.hand.highlighted == 1 then
			SMODS.Stickers["jojo_kiss"]:apply(G.hand.highlighted[1], true)
--			SMODS.Stickers["eternal"]:apply(G.hand.highlighted[1], true)
		else
			SMODS.Stickers["jojo_kiss"]:apply(G.jokers.highlighted[1], true)
--			SMODS.Stickers["eternal"]:apply(G.jokers.highlighted[1], true)
		end
	end,
	
	can_use = function(self, card)
		return (G.consumeables and #G.consumeables.highlighted == 2)
		or (G.jokers and #G.jokers.highlighted == 1)
		or (G.hand and #G.hand.highlighted == 1)
	end
}

SMODS.Consumable {
	key = 'refinedWater',
	set = 'jojo_Stand',
	
	config = { extra = { hands = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands } }
	end,
	
	atlas = 'items',
	pos = { x = 0, y = 3 },	

	
	use = function(self, card, area, copier)
		ease_hands_played(card.ability.extra.hands)
	end,
	
	can_use = function(self, card)
		return G.GAME.blind.in_blind
	end
}

SMODS.Consumable {
	key = 'tomatoSalad',
	set = 'jojo_Stand',
	
	config = { extra = { discards = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discards } }
	end,
	
	atlas = 'items',
	pos = { x = 1, y = 3 },	

	
	use = function(self, card, area, copier)
		ease_discard(card.ability.extra.discards)
	end,
	
	can_use = function(self, card)
		return G.GAME.blind.in_blind
	end
}

SMODS.Consumable {
	key = 'harlotSpaghetti',
	set = 'jojo_Stand',
	
	config = { extra = { chips = 50 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	
	atlas = 'items',
	pos = { x = 2, y = 3 },	

	
	can_use = function(self, card)
		return next(SMODS.find_card("j_jojo_stand_pearlJam"))
	end
}

SMODS.Consumable {
	key = 'meatAppleSauce',
	set = 'jojo_Stand',
	
	config = { extra = { mult = 10 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	atlas = 'items',
	pos = { x = 3, y = 3 },	

	
	can_use = function(self, card)
		return next(SMODS.find_card("j_jojo_stand_pearlJam"))
	end
}

SMODS.Consumable {
	key = 'flan',
	set = 'jojo_Stand',
	config = { max_highlighted = 1, min_highlighted = 1 },
	
	atlas = 'items',
	pos = { x = 4, y = 3 },	

	
	use = function(self, card, area, copier)
		local selectedCard = G.hand.highlighted[1]
		local probability = pseudorandom('flan' .. G.GAME.round_resets.ante)
		
		if probability < 19/40 then
			selectedCard:set_edition("e_foil")
		elseif probability < 323/400 then
			selectedCard:set_edition("e_holo")
		elseif probability < 31/32 then
			selectedCard:set_edition("e_polychrome")
		else
			selectedCard:set_edition("e_negative")
		end
	end
}

SMODS.Consumable {
	key = 'bruschetta',
	set = 'jojo_Stand',
	config = { extra = { blindPercentage = 7 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blindPercentage } }
	end,
	
	atlas = 'items',
	pos = { x = 5, y = 3 },	

	
	use = function(self, card, area, copier)
		local oldBlind = G.GAME.blind.chips
		local newBlind = oldBlind * (1 - card.ability.extra.blindPercentage / 100)
		local difference = oldBlind - newBlind
	
		G.GAME.blind.chips = newBlind
		
		local smoothness = 4
		for i = 1, 10 * smoothness do
			local timeDelay = 1/smoothness * bezier_tweening(i/(10 * smoothness))
			G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = timeDelay,
            func = function()
                G.GAME.blind.chip_text = number_format(oldBlind - i/(10 * smoothness) * difference)
				return true
            end
        }))
		end
	end,
	
	can_use = function(self, card)
		return G.GAME.blind.in_blind
	end
}

SMODS.Consumable {
	key = 'pizza',
	set = 'jojo_Stand',
	config = { extra = { useCount = 0, maxUseCount = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.useCount, card.ability.extra.maxUseCount } }
	end,
	
	atlas = 'items',
	pos = { x = 0, y = 4 },	

	
	use = function(self, card, area, copier)
		local probability = pseudorandom('pizza' .. G.GAME.round_resets.ante)
		
		valid_cards = {}
		for _, v in ipairs(G.hand.cards) do
			if not v.seal then
				valid_cards[#valid_cards + 1] = v
			end
		end
		
		local randomCard = pseudorandom_element(valid_cards, pseudoseed('pizza' .. G.GAME.round_resets.ante))
		
		if probability < 1/4 then
			randomCard:set_seal("Red")
		elseif probability < 1/2 then
			randomCard:set_seal("Blue")
		elseif probability < 3/4 then
			randomCard:set_seal("Purple")
		else
			randomCard:set_seal("Gold")
		end
		
		card.ability.extra.useCount = card.ability.extra.useCount + 1
	end,
	
	can_use = function(self, card)
		for _, v in ipairs(G.hand.cards) do
			if not v.seal then
				return true
			end
		end
		return false
	end,
	
	keep_on_use = function(self, card)
		return card.ability.extra.useCount + 1 < card.ability.extra.maxUseCount
	end
}

SMODS.Consumable {
	key = 'carrozza',
	set = 'jojo_Stand',
	
	config = { extra = { xMult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xMult } }
	end,
	
	atlas = 'items',
	pos = { x = 1, y = 4 },	
	
	can_use = function(self, card)
		return next(SMODS.find_card("j_jojo_stand_pearlJam"))
	end
}

SMODS.Consumable {
	key = 'cannolo',
	set = 'jojo_Stand',
	
	config = { max_highlighted = 1, min_highlighted = 1 },
	
	atlas = 'items',
	pos = { x = 2, y = 4},	

	
	use = function(self, card, area, copier)
		local selectedCard = G.hand.highlighted[1]
		
		if probability < 1/5 then
			selectedCard:set_ability("m_steel")
		elseif probability < 2/5 then
			selectedCard:set_ability("m_glass")
		elseif probability < 3/5 then
			selectedCard:set_ability("m_bonus")
		elseif probability < 4/5 then
			selectedCard:set_ability("m_mult")
		else
			selectedCard:set_ability("m_jojo_frozen")
		end
	end,
	
	can_use = function(self, card)
		for _, v in ipairs(G.hand.cards) do
			if not next(SMODS.get_enhancements(v)) then
				return true
			end
		end
		return false
	end
}

SMODS.Consumable {
	key = 'doppio',
	set = 'jojo_Stand',
	
	config = { extra = { speed = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.speed } }
	end,
	
	atlas = 'items',
	pos = { x = 3, y = 4 },	
	
	can_use = function(self, card)
		return next(SMODS.find_card("j_jojo_stand_pearlJam"))
	end
}

--------------------------------------------------------------------------------------------------- End of the Stand Summons

--------------------------------------------------------------------------------------------------- Start of the Scraps

SMODS.Consumable {
	key = 'water',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 0, y = 0 },	
	
	use = function(self, card, area, copier)
		return { message = "Sip..." }
	end,
	
	can_use = function(self, card)
		return true
	end
}

SMODS.Consumable {
	key = 'tomatoes',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 1, y = 0 },	
	
	use = function(self, card, area, copier)
		return { message = "Nom..." }
	end,
	
	can_use = function(self, card)
		return true
	end
}

SMODS.Consumable {
	key = 'spaghetti',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 2, y = 0 },	
	
	use = function(self, card, area, copier)
		return { message = "Nom..." }
	end,
	
	can_use = function(self, card)
		return true
	end
}

SMODS.Consumable {
	key = 'meat',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 3, y = 0 },	
	
	use = function(self, card, area, copier)
		return { message = "Nom..." }
	end,
	
	can_use = function(self, card)
		return true
	end
}

SMODS.Consumable {
	key = 'caramel',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 4, y = 0 },	
	
	use = function(self, card, area, copier)
		local probability = pseudorandom('caramel' .. G.GAME.round_resets.ante)
		
		valid_cards = {}
		for _, v in ipairs(G.hand.cards) do
			if not v.edition then
				valid_cards[#valid_cards + 1] = v
			end
		end
		
		local randomCard = pseudorandom_element(valid_cards, pseudoseed('caramel' .. G.GAME.round_resets.ante))
		
		if probability < 19/40 then
			randomCard:set_edition("e_foil")
		elseif probability < 323/400 then
			randomCard:set_edition("e_holo")
		elseif probability < 19/20 then
			randomCard:set_edition("e_polychrome")
		else
			randomCard:set_edition("e_negative")
		end
	end,
	
	can_use = function(self, card)
		for _, v in ipairs(G.hand.cards) do
			if not v.edition then
				return true
			end
		end
		return false
	end
}

SMODS.Consumable {
	key = 'bread',
	set = 'jojo_Scraps',
	config = { extra = { blindPercentage = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blindPercentage } }
	end,
	
	atlas = 'items',
	pos = { x = 5, y = 0 },	
	
	use = function(self, card, area, copier)
		local oldBlind = G.GAME.blind.chips
		local newBlind = oldBlind * (1 - card.ability.extra.blindPercentage / 100)
		local difference = oldBlind - newBlind
	
		G.GAME.blind.chips = newBlind
		
		local smoothness = 4
		for i = 1, 10 * smoothness do
			local timeDelay = 1/smoothness * bezier_tweening(i/(10 * smoothness))
			G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = timeDelay,
            func = function()
                G.GAME.blind.chip_text = number_format(oldBlind - i/(10 * smoothness) * difference)
				return true
            end
        }))
		end
	end,
	
	can_use = function(self, card)
		return G.GAME.blind.in_blind
	end
}

SMODS.Consumable {
	key = 'dough',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 0, y = 1 },	
	
	use = function(self, card, area, copier)
		local probability = pseudorandom('dough' .. G.GAME.round_resets.ante)
		
		valid_cards = {}
		for _, v in ipairs(G.hand.cards) do
			if not v.seal then
				valid_cards[#valid_cards + 1] = v
			end
		end
		
		local randomCard = pseudorandom_element(valid_cards, pseudoseed('dough' .. G.GAME.round_resets.ante))
		
		if probability < 1/4 then
			randomCard:set_seal("Red")
		elseif probability < 1/2 then
			randomCard:set_seal("Blue")
		elseif probability < 3/4 then
			randomCard:set_seal("Purple")
		else
			randomCard:set_seal("Gold")
		end
	end,
	
	can_use = function(self, card)
		for _, v in ipairs(G.hand.cards) do
			if not v.seal then
				return true
			end
		end
		return false
	end
}

SMODS.Consumable {
	key = 'mozzarella',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 1, y = 1 },	
	
	use = function(self, card, area, copier)
		return { message = "Nom..." }
	end,
	
	can_use = function(self, card)
		return true
	end
}

SMODS.Consumable {
	key = 'ricotta',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 2, y = 1 },	
	
	use = function(self, card, area, copier)
		local probability = pseudorandom('ricotta' .. G.GAME.round_resets.ante)
		
		valid_cards = {}
		for _, v in ipairs(G.hand.cards) do
			if not next(SMODS.get_enhancements(v)) then
				valid_cards[#valid_cards + 1] = v
			end
		end
		
		local randomCard = pseudorandom_element(valid_cards, pseudoseed('ricotta' .. G.GAME.round_resets.ante))
		
		if probability < 1/5 then
			randomCard:set_ability("m_steel")
		elseif probability < 2/5 then
			randomCard:set_ability("m_glass")
		elseif probability < 3/5 then
			randomCard:set_ability("m_bonus")
		elseif probability < 4/5 then
			randomCard:set_ability("m_mult")
		else
			randomCard:set_ability("m_jojo_frozen")
		end
	end,
	
	can_use = function(self, card)
		for _, v in ipairs(G.hand.cards) do
			if not next(SMODS.get_enhancements(v)) then
				return true
			end
		end
		return false
	end
}

SMODS.Consumable {
	key = 'coffeeBeans',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 3, y = 1 },	
	
	use = function(self, card, area, copier)
		return { message = "Nom..." }
	end,
	
	can_use = function(self, card)
		return true
	end
}

SMODS.Consumable {
	key = 'bolts',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 4, y = 1 },	
	
	can_use = function(self, card)
		return false
	end,
	
	add_to_deck = function(self, card, from_debuff)
		card.sell_cost = 2
	end
}

SMODS.Consumable {
	key = 'pebbles',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 5, y = 1 },	
	
	can_use = function(self, card)
		return false
	end,
	
	add_to_deck = function(self, card, from_debuff)
		card.sell_cost = 1
	end
}

SMODS.Consumable {
	key = 'coin',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 0, y = 2 },	
	
	can_use = function(self, card)
		return false
	end,
	
	add_to_deck = function(self, card, from_debuff)
		card.sell_cost = 3
	end
}

SMODS.Consumable {
	key = 'gem',
	set = 'jojo_Scraps',
	
	atlas = 'items',
	pos = { x = 1, y = 2 },	
	
	can_use = function(self, card)
		return false
	end,
	
	add_to_deck = function(self, card, from_debuff)
		card.sell_cost = 10
	end
}

--------------------------------------------------------------------------------------------------- End of the Scraps
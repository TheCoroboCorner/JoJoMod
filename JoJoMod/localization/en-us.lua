return {
	descriptions = {
		Back = {
			b_jojo_speed = {
				name = "Speed Deck",
				text = {
					"Start run with a {C:attention}Blueprint{},",
					"{C:attention}Moody Blues{}, and two {C:attention}Made In Heavens{},",
					"all {C:blue}Foil{} and {C:purple}Eternal"
				}
			},
			b_jojo_queensDream = {
				name = "Queen's Dream Deck",
				text = {
					"Start run with {C:attention}Kira{}'s",
					"stands, as well as {C:attention}Harvest,",
					"{C:attention}Stray Cat{}, and {C:attention}Soft & Wet,",
					"all {C:purple}Eternal"
				}
			},
			b_jojo_bucciarati = {
				name = "Mazzo Guardie del corpo",
				text = {
					"Start run with all of",
					"{C:attention}Bucciarati{}'s teammates",
					"{C:inactive}(Except Narancia)"
				}
			}
		},
		Joker = {
			-- Normal Stand Jokers
			j_jojo_stand_starPlatinum = {
				name = 'Star Platinum',
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"per {C:attention}consecutive hand{} played that",
					"is your most played {C:attention}poker hand",
					"{C:inactive}(Currently {C:mult}+#2#{} {C:inactive}Mult{C:inactive})",
					"{C:inactive}#5#",
					"{C:inactive}#6#"
				}
			},
			j_jojo_stand_magiciansRed = {
				name = 'Magician\'s Red',
				text = {
					"First discarded hand is {C:attention}destroyed{};",
					"hand size is {C:attention}decreased {}by the size of said hand",
					"until end of round"
				}
			},
			j_jojo_stand_hermitPurple = {
				name = 'Hermit Purple',
				text = {
					"\"...and the {C:attention}next card{} you\'ll draw",
					"will be the {C:attention, s:1.1}#1# of #2#{}!\""
				}
			},
			j_jojo_stand_silverChariot = {
				name = 'Silver Chariot',
				text = {
					"First hand of round has a",
					"{C:green}#1# in #2#{} chance to {C:attention}not",
					"{C:attention}cost a hand to play"
				}
			},
			j_jojo_stand_theWorld = {
				name = 'The World',
				text = {
					"{C:gold, E:1, s:1.2}Stops time{} until first",
					"discard or last hand",
					"{C:inactive}(Currently{} {C:chips}+#1#{} {C:inactive}Chips and{} {C:mult}+#2#{} {C:inactive}Mult)"
				}
			},
			j_jojo_stand_hangedMan = {
				name = 'Hanged Man',
				text = {
					"Played {C:attention}glass{} cards give {C:chips}+#1#{} Chips",
					"and played {C:attention}frozen{} cards give {C:chips}+#2#{} Chips",
					"when scored"
				}
			},
			j_jojo_stand_theSun = {
				name = 'The Sun',
				text = {
					"{C:chips}+#1#{} Chips and {C:red}#2# hand size",
					"for every hand played this round",
					"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
				}
			},
			j_jojo_stand_judgement = {
				name = 'Judgement',
				text = {
					"Triples all {C:attention}listed {C:green}probabilities",
					"{C:inactive}(ex: {C:green}1 in 4{C:inactive} -> {C:green}3 in 4{C:inactive})"
				}
			},
			j_jojo_stand_tohth = {
				name = 'Tohth',
				text = {
					"Earn {C:money}$#1#{} per scored card",
					"if {C:attention}poker hand{} is a {C:attention}#2#{},",
					"otherwise {C:attention}pay {C:money}$#1#{} per scored card,",
					"poker hand changes after",
					"playing hand"
				}
			},
			j_jojo_stand_osiris = {
				name = 'Osiris',
				text = {
					"Sell {C:attention}one quarter{} of current",
					"{C:attention}jokers{} to disable the",
					"current {C:attention}Boss Blind",
					"{C:inactive}(Currently #1#/#2#)"
				}
			},
			j_jojo_stand_crazyDiamond = {
				name = 'Crazy Diamond',
				text = {
					"{C:attention}Destroyed cards{} get",
					"{C:attention}restored"
				}
			},
			j_jojo_stand_theHand = {
				name = 'The Hand',
				text = {
					"If hand contains {C:attention}exactly{} three",
					"cards, {C:attention}destroy{} the middle card"
				}
			},
			j_jojo_stand_pearlJam = {
				name = 'Pearl Jam',
				text = {
					"All bought food scraps get {C:attention}cooked",
					"{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips, {C:mult}+#2# {C:inactive}Mult,",
					"{X:mult,C:white}X#3#{C:inactive} Mult, and {X:green,C:white}X#4#{C:inactive} Speed)"
				}
			},
			j_jojo_stand_heavensDoor = {
				name = 'Heaven\'s Door',
				text = {
					"{C:attention}All{} values on consumable",
					"cards are {C:attention}doubled"
				}
			},
			j_jojo_stand_harvest = {
				name = 'Harvest',
				text = {
					"When {C:attention}Blind{} is selected,",
					"picks up a random item",
					"{C:inactive}(These dirty casino floors probably",
					"{C:inactive}only have {C:attention}junk{C:inactive}, though...)"
				}
			},
			j_jojo_stand_atomHeartFather = {
				name = 'Atom Heart Father',
				text = { -- Note to self - Update this to have a tag for Stand Arrow when it's made
					"If {C:spectral}Stand Arrow{} is used, creates",
					"a {C:attention,T:e_negative}negative copy{} and {C:red,E:2}self destructs"
				}
			},
			j_jojo_stand_strayCat = {
				name = 'Stray Cat',
				text = {
					"When a card is sold, {C:attention}charges up an attack{}.",
					"Can stockpile up to {C:attention}three{} attacks",
					"{C:inactive}(Currently {C:attention}#1# {C:inactive}attacks stockpiled)"
				}
			},
			j_jojo_stand_sheerHeartAttack = {
				name = 'Sheer Heart Attack',
				text = {
					"Each played {C:attention}#1#{} is {C:attention}destroyed{},",
					"rank changes every round"
				}
			},
			j_jojo_stand_killerQueen = {
				name = 'Killer Queen',
				text = {
					"If {C:attention}first hand{} of round has",
					"only {C:attention}1{} card, destroy it",
					"and earn {C:money}$#1#"
				}
			},
			j_jojo_stand_goldExperience = {
				name = 'Gold Experience',
				text = {
					"{C:green}#1# in #2#{} chance to create a",
					"random {C:tarot}Tarot card{} when a {C:attention}face card",
					"is scored",
					"{C:inactive}(Must have room)"
					
				}
			},
			j_jojo_stand_stickyFingers = {
				name = 'Sticky Fingers',
				text = {
					"{C:attention}+#1# selection limit",
					"in booster packs"
				}
			},
			j_jojo_stand_blackSabbath = {
				name = 'Black Sabbath',
				text = { -- Note to self - Update this to have a tag for Stand Arrow when it's made
					"If {C:spectral}Stand Arrow{} is used,",
					"target {C:legendary}Requiem Joker{} is made {C:attention,T:e_negative}negative,",
					"{C:red,E:2}self destructs"
				}
			},
			j_jojo_stand_moodyBlues = {
				name = 'Moody Blues',
				text = {
					"Copies ability of",
					"{C:attention}Joker to the left"
				}
			},
			j_jojo_stand_sixPistols = {
				name = 'Six Pistols',
				text = { -- Note to self - Update this to have a tag for Bullet when it's made
					"When {C:attention}Blind {}is selected, creates a {C:attention,T:e_negative}negative",
					"{C:tarot,T:c_jojo_bullet}Bullet {}card. After {C:attention}sixth{} card is created,",
					"{C:red,E:2}self destructs",
					"{C:inactive}(#1# of 6)"
				}
			},
			j_jojo_stand_purpleHaze = {
				name = 'Purple Haze',
				text = {
					"When {C:attention}Blind{} is selected, destroy",
					"adjacent {C:attention}Jokers{} and permanently",
					"add {X:mult,C:white}X#1#{} Mult per Joker destroyed this way",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				}
			},
			j_jojo_stand_mrPresident = {
				name = 'Mr. President',
				text = {
					"{C:attention}+#1# {}consumable slot"
				}
			},
			j_jojo_stand_theGratefulDead = {
				name = 'The Grateful Dead',
				text = {
					"At the {C:attention}start of round{}, all cards",
					"in hand have their {C:attention}rank{} increased",
					"by {C:attention}#1#{}, and {C:attention}Kings{} are destroyed",
					"{C:inactive}({C:blue}Frozen{C:inactive} cards are immune)"
				}
			},
			j_jojo_stand_whiteAlbum = {
				name = 'White Album',
				text = {
					"{C:blue}Freezes{} a random card in played hand"
				}
			},
			j_jojo_stand_kiss = {
				name = 'Kiss',
				text = {
					"{C:green}#1# in #2#{} chance to create a {C:attention}Kiss",
					"{C:attention}Sticker{} when a consumable without a Kiss",
					"Sticker is used"
				}
			},
			j_jojo_stand_whitesnake = {
				name = 'Whitesnake',
				text = {
					"All {C:attention}destroyed cards{} have their",
					"{C:attention}editions{} added to this Joker,",
					"except negative editions",
					"{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips, {C:mult}+#2# {C:inactive}Mult,",
					"{C:inactive}and {X:mult,C:white}X#3#{C:inactive} Mult)"
				}
			},
			j_jojo_stand_dragonsDream = {
				name = 'Dragon\'s Dream',
				text = {
					"{C:money}+$#1#{} for each scored {C:attention}#2#{},",
					"{C:money}-$#1#{} for each scored {C:attention}#3#{},",
					"rank changes every round"
				}
			},
			j_jojo_stand_tuskAct1 = {
				name = 'Tusk ACT1',
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} mult",
					"when a {C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{} fails",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				}
			},
			j_jojo_stand_softAndWet = {
				name = 'Soft & Wet',
				text = { -- Note to self - Update this to have a tag for Bubble when it's made
					"When {C:attention}Blind {}is selected, creates",
					"a {C:attention,T:e_negative}negative{} {C:tarot}Bubble{} card"
				}
			},
			j_jojo_stand_theMattekudasai = {
				name = 'The Mattekudasai',
				text = {
					"If played hand contains a {C:attention}#1#{},",
					"create a {C:tarot,T:c_death}Death{} Tarot card,",
					"rank changes every round",
					"{C:inactive}(Must have room)"
					
				}
			},
			j_jojo_stand_bigmouthStrikesAgain = {
				name = 'Bigmouth Strikes Again',
				text = {
					"{C:attention}+#1#{} Joker slot"
				}
			},
			-- Requiem Stand Jokers
			j_jojo_requiem_silverChariot = {
				name = 'Chariot Requiem',
				text = { -- Note to self - Update this to have a tag for Eternal
					"Randomizes the played hand's {C:spectral}enhancements{}, {C:tarot}editions{},",
					"and {C:planet}seals{} among themselves, {C:green}#1# in #2#{} chance to",
					"add a new {C:spectral}enhancement{}, {C:tarot}edition{}, or {C:planet}seal"
				}
			},
			j_jojo_requiem_theWorld = {
				name = 'The World Over Heaven',
				text = {
					"{C:blue}+#1#{} hands, played cards are {C:attention}shuffled",
					"{C:attention}back into the deck",
					"{C:inactive}(Currently{} {C:chips}+#2#{} {C:inactive}Chips and{} {C:mult}+#3#{} {C:inactive}Mult)"
					
				}
			},
			j_jojo_requiem_killerQueen = {
				name = 'Killer Queen : Bites The Dust',
				text = {
					"If a {C:blue}hand{} or {C:red}discard{} destroys",
					"a card, it does not cost a {C:blue}hand{} or",
					"{C:red}discard{} to play",
				}
			},
			j_jojo_requiem_goldExperience = {
				name = 'Gold Experience Requiem',
				text = {
					"{C:red}+#1#{} discards, discards are {C:attention}shuffled",
					"{C:attention}back into the deck",
				}
			},
			j_jojo_requiem_cmoon = {
				name = 'C-Moon',
				text = {
					"Copies ability of adjacent {C:attention}Jokers",
					"{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips, {C:mult}+#2# {C:inactive}Mult,",
					"{C:inactive}and {X:mult,C:white}X#3#{C:inactive} Mult)"
				}
			},
			j_jojo_requiem_madeInHeaven = {
				name = 'Made In Heaven',
				text = { -- Note to self - Update this to have a tag for skip tags
					"{X:green,C:white}X#5#{} Speed when Blind is selected",
					"{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips, {C:mult}+#2# {C:inactive}Mult,",
					"{X:mult,C:white}X#3#{C:inactive} Mult, and {X:green,C:white}X#4#{C:inactive} Speed)"
				}
			},
			j_jojo_requiem_tuskAct2 = {
				name = 'Tusk ACT2',
				text = {
					"{C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{} now affects up to",
					"{C:attention}two Jokers{} and can {C:attention}upgrade",
					"Jokers with editions",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				}
			},
			j_jojo_requiem_tuskAct3 = {
				name = 'Tusk ACT3',
				text = {
					"{C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{} can make Jokers {C:attention,T:e_negative}negative",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				}
			},
			j_jojo_requiem_tuskAct4 = {
				name = 'Tusk ACT4',
				text = {
					"{C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{} now affects up to",
					"{C:attention}three Jokers{}, {X:chips,C:white}X#1#{} Chips per negative Joker",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				}
			},
			j_jojo_requiem_softAndWet = {
				name = 'Soft & Wet : Go Beyond',
				text = { -- Note to self - Update this to have a tag for Bubble when it's made
					"When {C:attention}Blind {}is selected, creates",
					"a {C:attention,T:e_negative}negative{}{C:spectral} Spinning Bubble{} card"
				}
			}
		},
		jojo_Stand = {
			c_jojo_bullet = {
				name = "Bullet",
				text = {
					"Destroys up to",
					"{C:attention}#1#{} selected card(s)"
				}
			},
			c_jojo_bubble = {
				name = "Bubble",
				text = {
					"Select {C:attention}#1#{} cards, copy",
					"the {C:attention}right{} card's enhancement",
					"onto the {C:attention}left{} card",
					"{C:inactive}(Drag to rearrange)"
				}
			},
			c_jojo_spinningBubble = {
				name = "Spinning Bubble",
				text = {
					"Select {C:attention}#1#{} cards,",
					"copy the {C:attention}right{} card's",
					"{C:spectral}enhancement{}, {C:tarot}edition{}, and {C:planet}seal",
					"onto the {C:attention}left{} card",
					"{C:inactive}(Drag to rearrange)"
				}
			},
			c_jojo_kiss = {
				name = "Kiss Sticker",
				text = {
					"{C:attention}Duplicates{} a selected card.",
					"The card and its clone will be",
					"{C:attention}destroyed{} at the end of the round"
				}
			},
			c_jojo_refinedWater = {
				name = "Refined Water",
				text = {
					"{C:blue}+#1#{} hand until",
					"end of round"
				}
			},
			c_jojo_tomatoSalad = {
				name = "Tomato Salad",
				text = {
					"{C:red}+#1#{} discard until",
					"end of round"
				}
			},
			c_jojo_harlotSpaghetti = {
				name = "Harlot Spaghetti",
				text = {
					"Each {C:attention}Pearl Jam{} gains",
					"{C:chips}+#1#{} Chips for the next hand"
				}
			},
			c_jojo_meatAppleSauce = {
				name = "Meat with Apple Sauce",
				text = {
					"Each {C:attention}Pearl Jam{} gains",
					"{C:mult}+#1#{} Mult for the next hand"
				}
			},
			c_jojo_flan = {
				name = "Flan",
				text = {
					"Adds a random {C:attention}edition",
					"to one selected card in hand"
				}
			},
			c_jojo_bruschetta = {
				name = "Bruschetta",
				text = {
					"Lowers the {C:attention}blind",
					"{C:attention}requirement by {C:attention}#1#%"
				}
			},
			c_jojo_pizza = {
				name = "Pizza",
				text = {
					"Adds a random {C:attention}seal",
					"to a random card in hand",
					"{C:inactive}(Used {C:attention}#1#{C:inactive}/{C:attention}#2# {C:inactive}times)"
				}
			},
			c_jojo_carrozza = {
				name = "Carrozza",
				text = {
					"Each {C:attention}Pearl Jam{} gains",
					"{X:mult,C:white}X#1#{} Mult for the next hand"
				}
			},
			c_jojo_cannolo = {
				name = "Cannolo Siciliano",
				text = {
					"Adds a random {C:attention}enhancement",
					"to one selected card in hand"
				}
			},
			c_jojo_doppio = {
				name = "Doppio",
				text = {
					"Each {C:attention}Pearl Jam{} gains",
					"{X:green,C:white}X#1#{} Speed for the rest of the ante"
				}
			},
		},
		jojo_Scraps = {
			c_jojo_water = {
				name = "Water",
				text = {
					"Just... ordinary water?"
				}
			},
			c_jojo_tomatoes = {
				name = "Fresh Tomatoes",
				text = {
					"Eating this on its own",
					"is fine, but... maybe",
					"you can {C:attention}use it in something..."
				}
			},
			c_jojo_spaghetti = {
				name = "Raw Spaghetti",
				text = {
					"I think you're supposed",
					"to {C:attention}cook it{} first..."
				}
			},
			c_jojo_meat = {
				name = "Raw Meat",
				text = {
					"You should probably {C:attention}cook",
					"{C:attention}it{} first before doing anything",
					"with it..."
				}
			},
			c_jojo_caramel = {
				name = "Raw Caramel",
				text = {
					"Adds a random {C:attention}edition",
					"to a random card in hand",
					"{C:inactive}(Surely there's some",
					"{C:attention}recipes {C:inactive}to use this in...)"
				}
			},
			c_jojo_bread = {
				name = "Bread",
				text = {
					"Lowers the {C:attention}blind",
					"{C:attention}requirement by {C:attention}#1#%",
					"{C:inactive}(It's a bit plain... surely there",
					"{C:inactive}are some {C:attention}recipes {C:inactive}around here...)"
				}
			},
			c_jojo_dough = {
				name = "Raw Dough",
				text = {
					"Adds a random {C:attention}seal",
					"to a random card in hand",
					"{C:inactive}(Maybe {C:attention}cook it {C:inactive}first?)"
				}
			},
			c_jojo_mozzarella = {
				name = "Mozzarella",
				text = {
					"Nice on its own, but could",
					"be {C:attention}cooked into something",
					"grand, I bet..."
				}
			},
			c_jojo_ricotta = {
				name = "Ricotta",
				text = {
					"Adds a random {C:attention}enhancement",
					"to a random card in hand",
					"{C:inactive}Would go great in some {C:attention}cannoli{C:inactive}..."
				}
			},
			c_jojo_coffeeBeans = {
				name = "Coffee Beans",
				text = {
					"...shouldn't they be",
					"{C:attention}ground up{} first?"
				}
			},
			c_jojo_bolts = {
				name = "Nuts and Bolts",
				text = {
					"I'm fairly certain these",
					"are supposed to be attached",
					"to something..."
				}
			},
			c_jojo_pebbles = {
				name = "Stones and Pebbles",
				text = {
					"How did these get",
					"shuffled into the deck?"
				}
			},
			c_jojo_coin = {
				name = "Small Coin",
				text = {
					"Finders keepers!"
				}
			},
			c_jojo_gem = {
				name = "Gemstone",
				text = {
					"Ooh, shiny..."
				}
			},
		},
		Spectral = {
			c_jojo_standArrow = {
				name = "Stand Arrow",
				text = {
					"{C:legendary}Awakens{} a compatible Joker"
				}
			}
		},
		Enhanced = {
			m_jojo_frozen = {
				name = "Frozen Card",
				text = {
					"{X:chips,C:white}X#1#{} Chips",
					"{C:green}#2# in #3#{} chance to",
					"destroy card"
				}
			}
		},
		Other = {
			jojo_kiss = {
				name = "Kiss Sticker",
				text = {
					"{C:attention}Duplicates{} the card;",
					"{C:attention}destroyed{} at the end",
					"of round"
				}
			},
			jojo_stoppedTime = {
				name = "Stopped Time",
				text = {
					"{C:chips}Chips{} and {C:mult}Mult{} achieved during stopped",
					"time {C:attention}stack up{} instead of scoring"
				}
			},
			speed = {
				name = "Speed",
				text = {
					"Every {X:green,C:white}X1{} Speed",
					"obtained is one",
					"{C:attention}trigger"
				}
			},
			jojo_stand_strayCat_attack = {
				name = "Bubble Attack",
				text = {
					"When next hand is",
					"played, {C:attention}attacks{} and",
					"{C:attention}destroys{} one random",
					"card not in played hand"
				}
			},
			jojo_requiem = {
				name = "Requiem Joker",
				text = {
					"A Joker only attained by",
					"{C:legendary}ascension{} through use of a",
					"{C:attention}legendary artifact{}. Few can",
					"ascend, but the ones who do",
					"gain {C:legendary}ultimate power{}."
				}
			},
			jojo_requiem_theWorld_ability = {
				name = "Requiem",
				text = {
					"Retains the ability",
					"of {C:attention}The World"
				}
			},
			jojo_requiem_killerQueen_ability = {
				name = "Requiem",
				text = {
					"Retains the ability",
					"of {C:attention}Killer Queen"
				}
			},
			jojo_requiem_goldExperience_ability = {
				name = "Requiem",
				text = {
					"Retains the ability",
					"of {C:attention}Gold Experience"
				}
			},
			jojo_requiem_cmoon_ability = {
				name = "Requiem",
				text = {
					"Retains the stats that",
					"{C:attention}Whitesnake{} had built up"
				}
			},
			jojo_requiem_madeInHeaven_ability = {
				name = "Requiem",
				text = {
					"Retains the ability",
					"of {C:attention}C-Moon",
					"and the stats that",
					"{C:attention}Whitesnake{} had built up"
				}
			},
			jojo_requiem_tuskAct2_ability = {
				name = "Requiem",
				text = {
					"Retains the ability",
					"of {C:attention}Tusk ACT1"
				}
			},
			jojo_requiem_tuskAct3_ability = {
				name = "Requiem",
				text = {
					"Retains the abilities of",
					"previous {C:attention}Tusk{} stages"
				}
			},
			jojo_requiem_tuskAct4_ability = {
				name = "Requiem",
				text = {
					"Retains the abilities of",
					"previous {C:attention}Tusk{} stages"
				}
			},
			jojo_requiem_softAndWet_ability = {
				name = "Requiem",
				text = {
					"Retains the ability",
					"of {C:attention}Soft & Wet"
				}
			}
		}
	},
	misc = {
			dictionary = {
				k_jojo_requiem = "Requiem",
				k_jojo_stand = "Stand",
				b_jojo_stand_cards = "Stand Summons",
				k_jojo_scraps = "Scraps",
				b_jojo_scraps_cards = "Scraps"
			},
			labels = {
				jojo_requiem = "Requiem",
				jojo_stand = "Stand",
				jojo_scraps = "Scraps",
				jojo_kiss = "Kiss"
			}
	}
}
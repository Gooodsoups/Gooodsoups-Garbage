local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

-- Crimson
SMODS.Back {
    key = "GG_crimsondeck",
    atlas = "atlasdecks",
    pos = {
        x = 0,
        y = 0
    },

    loc_vars = function(info_queue)
        return {
            vars = {
                1
            }
        }
    end,

    loc_txt = {
        name = "Crimson Deck",
        text = {
            "Skipping {C:attention}Blinds{} open the shop",
            "{C:money}$#1#{s:0.85} per remaining {C:red}Discard",
        }
    },

    apply = function(self, deck)
        G.GAME.modifiers.money_per_discard = 1
    end,

    calculate = function(self, deck, context)
        if context.skip_blind or (context.ending_booster and G.shop) then
            stop_use()
            G.deck:shuffle('cashout'..G.GAME.round_resets.ante)
            G.deck:hard_set_T()
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}
            G.GAME.current_round.free_rerolls = G.GAME.round_resets.free_rerolls
            calculate_reroll_cost(true)
            if context.skip_blind then
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object.pop_delay = 0
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object:pop_out(5)
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object.pop_delay = 0
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object:pop_out(5) 
            end
            delay(0.3)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    if G.blind_select and context.skip_blind then 
                        G.blind_select:remove()
                        G.blind_prompt_box:remove()
                        G.blind_select = nil
                    end
                    G.STATE = G.STATES.SHOP
                    G.GAME.shop_free = nil
                    G.GAME.shop_d6ed = nil
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        end
    end
}

-- Vampiric
SMODS.Back {
    key = "GG_vampiricdeck",
    atlas = "atlasdecks",
    pos = {
        x = 1,
        y = 0
    },

    config = {
        multi = 0,
        multigain = 2
    },

    loc_txt = {
        name = "Vampiric Deck",
        text = {
            "At the end of ante",
            "remove all {C:attention}Enhancements{},",
            "gain {C:mult}+2{} Mult for every",
            "{C:attention}Enhancement{} removed"
        }
    },

    calculate = function(self, deck, context)
        if context.end_of_round and context.main_eval and context.beat_boss then
            local changed = false

            for k, v in pairs(G.playing_cards) do
                if v.config.center.key ~= "c_base" then
                    v:set_ability("c_base")
                    deck.effect.config.multi = (deck.effect.config.multi or 0) + deck.effect.config.multigain

                    changed = true
                end
            end

            if changed then
                return {
                    message = "+" .. deck.effect.config.multi .. " Mult"
                }
            end
        end

        if context.initial_scoring_step then
            return {
                mult = deck.effect.config.multi
            }
        end
    end
}

-- Messy
SMODS.Back {
    key = "GG_messydeck",
    atlas = "atlasholders",
    pos = {
        x = 4,
        y = 2
    },
    
    loc_txt = {
        name = "Messy Deck",
        text = {
            "Each card may start with an",
            "{C:attention}enhancement{}, {C:attention}edition{} or {C:attention}seal{},",
            "{C:red}X2{} base Blind size"
        }
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                for k, v in pairs(G.playing_cards) do
                    local enhancements = G.P_CENTER_POOLS.Enhanced
                    local editions = G.P_CENTER_POOLS.Edition
                    local seals = G.P_CENTER_POOLS.Seal

                    local abilities = {
                        enhancements[math.ceil(pseudorandom("messyEN", 0.001, #enhancements))],
                        editions[math.ceil(pseudorandom("messyED", 0.001, #editions))],
                        seals[math.ceil(pseudorandom("messySE", 0.001, #seals))]
                    }

                    if (not (abilities[1] == nil or abilities[2] == nil or abilities[3] == nil)) then
                        if pseudorandom("messydeck1") < 0.75 then
                            v:set_ability(abilities[1].key)
                        end

                        if pseudorandom("messydeck2") < 0.25 then
                            v:set_edition(abilities[2].key)
                        end

                        if pseudorandom("messydeck3") < 0.1 then
                            v:set_seal(abilities[3].key)
                        end
                    end
                end

                G.GAME.starting_params.ante_scaling = 2

                return true
            end
        }))
    end
}

-- Eclipse
SMODS.Back {
    key = "GG_eclipsedeck",
    atlas = "atlasholders",
    pos = {
        x = 4,
        y = 2
    },

    loc_txt = {
        name = "Eclipse Deck",
        text = {
            "Cards may be drawn face down",
            "according to the amount of",
            "hands left, {C:blue}+2{} hands",
            "every round"
        }
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = "before",
            func = function()
                ease_hands_played(2)
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 2

                return true
            end
        }))
    end,

    calculate = function(self, deck, context)
        if context.stay_flipped then
            if pseudorandom("eclipsedeck") < G.GAME.current_round.hands_left * 0.05 then
                return {
                    stay_flipped = true
                }
            end
        end

        -- Using this to patch the fucking flipped card inconsistency
        if context.initial_scoring_step then
            local hand = context.full_hand

            for k, v in pairs(hand) do
                if v.facing == "back" then
                    v:flip()
                end
            end
        end
    end
}

-- Lazarus
SMODS.Back {
    key = "GG_lazarusdeck",
    atlas = "atlasholders",
    pos = {
        x = 4,
        y = 2
    },

    config = {
        xmult = 1.5,
        revivetimermax = 4,
        xmulttimermax = 2,
        revivetimer = 4,
        xmulttimer = 2
    },

    loc_txt = {
        name = "Lazarus Deck",
        text = {
            "Gain {X:mult,C:white}X1.5{} Mult for {C:attention}2{} antes",
            "upon reviving, every {C:attention}4{} antes",
            "this deck will save you from death"
        }
    },

    calculate = function(self, deck, context)
        if context.game_over and deck.effect.config.revivetimer <= 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound("tarot1")

                    return true
                end
            }))

            deck.effect.config.revivetimer = deck.effect.config.revivetimermax
            deck.effect.config.xmulttimer = deck.effect.config.xmulttimermax

            return {
                message = localize("k_saved_ex"),
                saved = true
            }
        end

        if context.joker_main and deck.effect.config.xmulttimer > 0 then
            return {
                xmult = deck.effect.config.xmult
            }
        end

        if context.end_of_round and context.main_eval and context.beat_boss then
            deck.effect.config.revivetimer = deck.effect.config.revivetimer - 1
            deck.effect.config.xmulttimer = deck.effect.config.xmulttimer - 1

            if deck.effect.config.revivetimer <= 0 then
                return {
                    message = localize("k_active_ex")
                } 
            else
                return {
                    message = deck.effect.config.revivetimer
                } 
            end
        end
    end
}

-- Corrupted
SMODS.Back {
    key = "GG_corrupteddeck",
    atlas = "atlasdecks",
    pos = {
        x = 2,
        y = 0
    },

    config = {
        anaglyph = false,
        plasma = false,
        scoremultiplier = 1
    },

    loc_txt = {
        name = "Q29ycnVwdGVkIERlY2s=",
        text = {
            "Start with {E:1}??? {C:chips}hands{} and",
            "{E:1}??? {C:mult}discards{}, at the end",
            "of Ante, {E:1}??????"
        }
    },

    apply = function(self, deck)
        G.E_MANAGER:add_event(Event({
            trigger = "before",
            func = function()
                -- the most abhorrent coding jesus fucking christ brace yourselves please

                local smods_showman_ref = SMODS.showman
                function SMODS.showman(card_key)
                    return true
                end

                local hands_change = math.floor(pseudorandom("GG_corrupteddeck") * 6 + 0.9999) - 3
                local discards_change = math.floor(pseudorandom("GG_corrupteddeck") * 6 + 0.9999) - 3
                local hand_size_change = math.floor(pseudorandom("GG_corrupteddeck") * 5 + 0.9999) - 3
                local consumable_change = math.floor(pseudorandom("GG_corrupteddeck") * 2 + 0.9999) - 1
                
                -- the worst part, 3 random vanilla decks, but im lazy so ima just hard-code the effects

                local decks = {
                    "blue", "red", "yellow", "green", "black", "magic", "nebula", "ghost", "abandoned", "checkered", "zodiac", "painted", "anaglyph", "plasma", "erratic"
                }

                local selections = CalcLib.get_random_items(decks, 3, "GG_corrupteddeck")

                for i = 1, #selections do
                    if selections[i] == "blue" then
                        hands_change = hands_change + 1
                    end

                    if selections[i] == "red" then
                        discards_change = discards_change + 1
                    end

                    if selections[i] == "yellow" then
                        G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + 10
                    end

                    if selections[i] == "green" then
                        G.GAME.modifiers.no_interest = true
                        G.GAME.modifiers.money_per_hand = 2
                        G.GAME.modifiers.money_per_discard = 1
                    end

                    if selections[i] == "black" then
                        hands_change = hands_change - 1

                        if G.jokers then
                            G.jokers.config.card_limit = G.jokers.config.card_limit + 1 
                        end
                    end

                    if selections[i] == "magic" then
                        for i = 1, 2 do
                            local card = SMODS.add_card({ key = "c_fool" })
                            card:set_edition({negative = true}, true)
                        end
                    end

                    if selections[i] == "nebula" then
                        local card = SMODS.add_card({ key = "c_black_hole" })
                    end

                    if selections[i] == "ghost" then
                        G.GAME.spectral_rate = 2
                        local card = SMODS.add_card({ key = "c_hex" })
                    end

                    if selections[i] == "abandoned" then
                        for k, v in pairs(G.playing_cards) do
                            if v:is_face() then
                                SMODS.destroy_cards(v)
                            end
                        end
                    end

                    if selections[i] == "checkered" then
                        for k, v in pairs(G.playing_cards) do
                            if v.base.suit == 'Clubs' then 
                                v:change_suit('Spades')
                            end
                            if v.base.suit == 'Diamonds' then 
                                v:change_suit('Hearts')
                            end
                        end
                    end

                    if selections[i] == "zodiac" then
                        local mod = 1

                        G.GAME.shop.joker_max = G.GAME.shop.joker_max + mod
                        if G.shop_jokers and G.shop_jokers.cards then
                            if mod < 0 then
                                --Remove jokers in shop
                                for i = #G.shop_jokers.cards, G.GAME.shop.joker_max+1, -1 do
                                    if G.shop_jokers.cards[i] then
                                        G.shop_jokers.cards[i]:remove()
                                    end
                                end
                            end
                            
                            G.shop_jokers.config.card_limit = G.GAME.shop.joker_max
                            if mod > 0 then
                                for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
                                    G.shop_jokers:emplace(create_card_for_shop(G.shop_jokers))
                                end
                            end
                        end
                    end

                    if selections[i] == "painted" then
                        hand_size_change = hand_size_change + 2
                    end

                    if selections[i] == "anaglyph" then
                        deck.effect.config.anaglyph = true
                    end

                    if selections[i] == "plasma" then
                        deck.effect.config.plasma = true
                        deck.effect.config.scoremultiplier = 2
                    end

                    if selections[i] == "erratic" then
                        G.GAME.starting_params.erratic_suits_and_ranks = true
                    end
                end

                -- phew

                if G.hand then
                    G.hand:change_size(hand_size_change)
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit + consumable_change

                    ease_hands_played(hands_change)
                    G.GAME.round_resets.hands = G.GAME.round_resets.hands + hands_change

                    ease_discard(discards_change)
                    G.GAME.round_resets.discards = G.GAME.round_resets.discards + discards_change

                    SMODS.change_booster_limit(-2)
                end

                G.GAME.starting_params.ante_scaling = math.floor(pseudorandom("GG_corrupteddeck")*20)/10 * deck.effect.config.scoremultiplier
                G.GAME.discount_percent = (pseudorandom("GG_corrupteddeck") + 0.25)      

                if G.jokers then
                    G.jokers.config.card_limit = G.jokers.config.card_limit + math.floor(pseudorandom("GG_corrupteddeck")*4+0.9999) - 2

                    local card = create_card("Joker", G.jokers, nil, "GG_miscellaneous", nil, nil, nil, "GG_corrupted")
                    card:add_to_deck()
                    card:start_materialize()
                    G.jokers:emplace(card)
                end

                return true
            end
        }))
    end,

    calculate = function(self, deck, context)
        if context.end_of_round and context.main_eval and context.beat_boss then
            deck.effect.config.scoremultiplier = deck.effect.config.scoremultiplier + 0.25
            
            G.GAME.starting_params.ante_scaling = math.floor(pseudorandom("GG_corrupteddeck")*20)/10 * deck.effect.config.scoremultiplier
            G.GAME.discount_percent = (pseudorandom("GG_corrupteddeck") + 0.25)

            if deck.effect.config.anaglyph then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end
                }))
            end
        end

        if context.final_scoring_step then
            if deck.effect.config.plasma then
                return {
                    balance = true
                }
            end
        end

        if context.buying_card then
            local yes = false
            
            for k, v in pairs(G.jokers.cards) do
                if v == context.card then
                    yes = true
                end
            end

            if not yes then return end

            local card = context.card
            
            SMODS.destroy_cards(card)
            SMODS.add_card({ key = "j_GG_corrupted" })
        end
    end
}
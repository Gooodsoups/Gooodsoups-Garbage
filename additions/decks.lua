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

    apply = function(self, deck, context)
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
            "hands left, {C:blue}+1{} hand",
            "every round"
        }
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                ease_hands_played(1)
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1

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
local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

SMODS.ConsumableType {
    key = "GG_sigils",
    primary_colour = HEX("d745c3"),
    secondary_colour = HEX("d745c3"),

    loc_txt = {
        name = "Sigils",
        collection = "Sigils",
        undiscovered = {
            name="Not Discovered",
            text={
                "Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does",
            },
        }
    },

    shop_rate = 0,
    select_card = "consumeable"
}

-- Sigil of Hope
SMODS.Consumable {
    key = "GG_sigilhope",
    set = "GG_sigils",

    atlas = "atlasholders",
    pos = {
        x = 3,
        y = 2
    },

    cost = 4,

    loc_vars = function(self, info_queue, card)
        return {
            key = "co_GG_sigilhope",
            vars = {
                G.GAME.probabilities.normal
            }
        }
    end,

    can_use = function(self, card)
        local statement = #G.hand.cards > 0
        
        return statement
    end,

    use = function(self, card, area, copier)
        if not G.hand then return end

        if not (pseudorandom("GG_sigilhope") < G.GAME.probabilities.normal / 2) then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,

                func = function()
                    attention_text({
                        text = localize("k_nope_ex"),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = HEX("d745c3"),
                        align = (G.STATES.SMODS_BOOSTER_OPENED) and "tm" or "cm",
                        offset = {x = 0, y = (G.STATES.SMODS_BOOSTER_OPENED and -0.2 or 0)},
                        silent = true
                    })

                    return true
                end
            }))

            delay(0.2)

            return
        end
        
        local cards = CalcLib.get_random_items(G.hand.cards, 3, "co_GG_sigilhope")

        card:juice_up(0.4, 0.6)

        for i = 1, #cards do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.05,
                func = function()
                    cards[i]:highlight(true)

                    return true
                end
            }))
        end

        delay(0.2)

        for i = 1, #cards do
            local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.15,
                func = function()
                    cards[i]:flip()
                    play_sound("card1", percent)

                    cards[i].ability.perma_mult = cards[i].ability.perma_mult + 5

                    return true
                end
            }))
        end

        delay(0.5)

        for i = 1, #cards do
            local percent = 0.85 - (i - 0.999) / (#cards - 0.998) * 0.3

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.15,
                func = function()
                    cards[i]:flip()
                    
                    play_sound("card1", percent)

                    return true
                end
            }))
        end

        delay(0.2)

        for i = 1, #cards do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.05,
                func = function()
                    cards[i]:highlight(false)

                    return true
                end
            }))
        end
    end
}

-- Sigil of Grace
SMODS.Consumable {
    key = "GG_sigilgrace",
    set = "GG_sigils",

    atlas = "atlasholders",
    pos = {
        x = 3,
        y = 2
    },

    cost = 4,

    loc_vars = function(self, info_queue, card)
        return {
            key = "co_GG_sigilgrace",
            vars = {
                G.GAME.probabilities.normal
            }
        }
    end,

    can_use = function(self, card)
        local statement = #G.hand.cards > 0
        
        return statement
    end,

    use = function(self, card, area, copier)
        if not G.hand then return end
        
        if not (pseudorandom("GG_sigilhope") < G.GAME.probabilities.normal / 2) then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,

                func = function()
                    attention_text({
                        text = localize("k_nope_ex"),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = HEX("d745c3"),
                        align = (G.STATES.SMODS_BOOSTER_OPENED) and "tm" or "cm",
                        offset = {x = 0, y = (G.STATES.SMODS_BOOSTER_OPENED and -0.2 or 0)},
                        silent = true
                    })

                    return true
                end
            }))

            delay(0.2)

            return
        end

        local cards = CalcLib.get_random_items(G.hand.cards, 4, "co_GG_sigilgrace")

        card:juice_up(0.4, 0.6)

        for i = 1, #cards do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.05,
                func = function()
                    cards[i]:highlight(true)

                    return true
                end
            }))
        end

        delay(0.2)

        for i = 1, #cards do
            local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.15,
                func = function()
                    cards[i]:flip()
                    play_sound("card1", percent)

                    cards[i].ability.perma_bonus = cards[i].ability.perma_bonus + 25

                    return true
                end
            }))
        end

        delay(0.5)

        for i = 1, #cards do
            local percent = 0.85 - (i - 0.999) / (#cards - 0.998) * 0.3

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.15,
                func = function()
                    cards[i]:flip()
                    
                    play_sound("card1", percent)

                    return true
                end
            }))
        end

        delay(0.2)

        for i = 1, #cards do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.05,
                func = function()
                    cards[i]:highlight(false)

                    return true
                end
            }))
        end
    end
}

-- Sigil of Wealth
SMODS.Consumable {
    key = "GG_sigilwealth",
    set = "GG_sigils",

    atlas = "atlasholders",
    pos = {
        x = 3,
        y = 2
    },

    cost = 4,

    loc_vars = function(self, info_queue, card)
        return {
            key = "co_GG_sigilwealth",
            vars = {
                G.GAME.probabilities.normal
            }
        }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        if not (pseudorandom("GG_sigilwealth") < G.GAME.probabilities.normal / 3) then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,

                func = function()
                    attention_text({
                        text = localize("k_nope_ex"),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = HEX("d745c3"),
                        align = (G.STATES.SMODS_BOOSTER_OPENED) and "tm" or "cm",
                        offset = {x = 0, y = (G.STATES.SMODS_BOOSTER_OPENED and -0.2 or 0)},
                        silent = true
                    })

                    return true
                end
            }))

            delay(0.2)

            return
        end

        ease_dollars(25)
    end
}
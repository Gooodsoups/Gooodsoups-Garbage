-- Amplifier
SMODS.Enhancement {
    key = "GG_amplifier",
    atlas = "atlasenhancements",
    pos = {
        x = 0,
        y = 0
    },

    config = {
        apower = 0.03
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "m_GG_amplifier",
            vars = {
                colours = {
                    SMODS.Gradients.GG_C_power
                },
                card.ability.apower
            }
        }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                power = card.ability.apower
            } 
        end
    end
}

-- Reflective
SMODS.Shader {
    key = "reflective",
    path = "reflective.fs"
}

SMODS.Edition {
    key = "GG_reflective",
    shader = "reflective",
    
    loc_vars = function(self, info_queue, card)
        return {
            key = "e_GG_reflective"
        }
    end,

    weight = 6,
    extra_cost = 4,
    apply_to_float = true,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local cards = context.scoring_hand

            local idx = nil
            for i = 1, #cards do
                if cards[i] == card then
                    idx = i
                    break
                end
            end

            if not idx then return end

            local other = nil
            local i = 1

            while true do
                if idx - i < 1 then break end

                if cards[idx - i].edition and cards[idx - i].edition.key ~= "e_GG_reflective" --[[and (cards[idx - i].edition.key == "e_foil" or cards[i].edition.key == "e_holo" or cards[idx - i].edition.key == "e_polychrome")]] then
                    other = cards[idx - i]
                    break
                end

                i = i + 1
            end

            if other and other.edition then
                local effect = other:get_edition()

                if effect then
                    local ret = {}
                    
                    if effect.chip_mod then ret.chips = effect.chip_mod end
                    if effect.x_chip_mod then ret.chips = effect.x_chip_mod end
                    if effect.mult_mod then ret.mult = effect.mult_mod end
                    if effect.x_mult_mod then ret.xmult = effect.x_mult_mod end
                    
                    if context.cardarea == other.area then
                        return ret
                    end
                end
            end
        end
    end
}

-- Bronze
SMODS.Shader {
    key = "bronze",
    path = "bronze.fs"
}

SMODS.Edition {
    key = "GG_bronze",
    shader = "bronze",

    config = {
        xchips = 1.2
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "e_GG_bronze",
            vars = {
                card.edition.xchips
            }
        }
    end,

    weight = 6,
    extra_cost = 4,
    apply_to_float = true,

    calculate = function(self, card, context)
        if context.main_scoring then
            local scored = context.scoring_hand
            local played = G.play.cards

            local isPlayed = false
            local isScored = false

            for k, v in pairs(played) do
                if v == card then
                    isPlayed = true
                    break
                end
            end

            for k, v in pairs(scored) do
                if v == card then
                    isScored = true
                    break
                end
            end

            if isPlayed and not isScored then
                return {
                    xchips = 1.2
                }
            end
        end
    end
}

-- tainted
SMODS.Shader {
    key = "tainted",
    path = "tainted.fs"
}

SMODS.Edition {
    key = "GG_tainted",
    shader = "tainted",

    config = {
        localization = "e_GG_taintedjoker",
        xmult = 0.75
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = card.edition.localization,
            vars = {
                card.edition.xmult
            }
        }
    end,

    weight = 3,
    extra_cost = 4,
    apply_to_float = true,

    calculate = function(self, card, context)
        if card.playing_card then
            card.edition.localization = "e_GG_taintedcard"
            card.edition.xmult = 0.9
        else
            card.edition.localization = "e_GG_taintedjoker"
            card.edition.xmult = 0.75
        end

        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = 1
            }
        end

        if context.main_scoring and (context.cardarea == G.play or context.cardarea == G.jokers) then
            return {
                xmult = card.edition.xmult
            }
        end
    end
}

-- Bronze
SMODS.Shader {
    key = "rusty",
    path = "rusty.fs"
}

SMODS.Edition {
    key = "GG_rusty",
    shader = "rusty",

    config = {
        xmult = 0.8,
        xmultloss = 0.01,
        moneyearned = 3
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "e_GG_rusty",
            vars = {
                card.edition.xmult,
                card.edition.xmultloss,
                card.edition.moneyearned
            }
        }
    end,

    weight = 5,
    extra_cost = 2,
    apply_to_float = true,

    calc_dollar_bonus = function(self, card)
        return lenient_bignum(card.edition.moneyearned)
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.edition.xmult = card.edition.xmult - card.edition.xmultloss

            return {
                message = "-X"..tostring(card.edition.xmultloss),
                colour = G.C.MULT
            }
        end
    end
}

--[[SMODS.Edition {
    key = "GG_test2",
    shader = "reflective",
    
    loc_vars = function(self, info_queue, card)
        return {
            key = "e_GG_reflective"
        }
    end,

    weight = 6,
    extra_cost = 4,
    apply_to_float = true,

    on_apply = function(card)
        if card.area.config.type == "shop" then
            local def = {
            n=G.UIT.ROOT, config = {id = 'freeze', ref_table = card, minh = 1.1, padding = 0.1, align = 'cl', colour = HEX("3cb0b5"), shadow = true, r = 0.08, minw = 1.1, func = 'can_freeze', one_press = true, button = 'freeze', hover = true, focus_args = {type = 'none'}}, nodes={
                {n=G.UIT.B, config = {w=-0.1,h=0.6}},
                {n=G.UIT.C, config = {align = 'cm'}, nodes={
                {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                    {n=G.UIT.T, config={text = "freeze",colour = G.C.WHITE, scale = 1}}
                }},
                }} 
            }}
            
            card.children.freeze = UIBox({
                definition = def,
                config = {
                    align = "cl",
                    offset = {
                        x = 0,
                        y = 0.5,
                    },
                    bond = "Strong",
                    parent = card,
                },
            })
        end
    end
}]]
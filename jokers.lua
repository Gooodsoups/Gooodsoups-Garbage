local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

-- Commons

-- Impulse Joker
SMODS.Joker {
    key = "GG_impulsejoker",
    atlas = "atlasjonklers",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 4,

    blueprint_compat = true,

    config = {
        apower = 0.05
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_impulsejoker",
            vars = {
                colours = {
                    SMODS.Gradients.GG_C_power
                },
                card.ability.apower
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                power = card.ability.apower
            }
        end
    end
}

-- Alphabet
SMODS.Joker {
    key = "GG_alphabet",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 4,

    blueprint_compat = true,

    config = {
        func = 0,
        multigain = 3
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_alphabet",
            vars = {
                card.ability.func,
                card.ability.multigain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    other_joker = G.jokers.cards[i + 1]
                end
            end

            if not other_joker then
                return {
                    mult = 0
                }
            else
                local name = other_joker.config.center.name
                local unique = {}
                local uniqueLetters = 0

                if other_joker.config.center.mod then
                    name = name:gsub("^j_"..other_joker.config.center.mod.prefix.."_","")
                end
                
                for char in name:lower():gmatch(".") do
                    if not unique[char] and char ~= " " then
                        unique[char] = true
                        uniqueLetters = uniqueLetters + 1
                    end
                end

                return {
                    mult = uniqueLetters * card.ability.multigain
                }
            end
        end
    end,

    update = function(self, card, dt)
        if not G.jokers then return end

        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                other_joker = G.jokers.cards[i + 1]
            end
        end

        if not other_joker then
            card.ability.func = 0
        else
            local name = other_joker.config.center.name
            local unique = {}
            local uniqueLetters = 0
            
            if other_joker.config.center.mod then
                name = name:gsub("^j_"..other_joker.config.center.mod.prefix.."_","")
            end
            
            for char in name:lower():gmatch(".") do
                if not unique[char] and char ~= " " then
                    unique[char] = true
                    uniqueLetters = uniqueLetters + 1
                end
            end

            card.ability.func = uniqueLetters * card.ability.multigain
        end
    end
}

-- Hot Streak
SMODS.Joker {
    key = "GG_hotstreak",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 6,

    config = {
        hand_type = "None",
        xmult = 1,
        streak = 0,
        xmultgain = 0.25
    },

    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_hotstreak",
            vars = {
                card.ability.hand_type,
                card.ability.streak,
                card.ability.xmult,
                card.ability.xmultgain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if card.ability.hand_type == "None" then
                card.ability.hand_type = context.scoring_name
            end

            if card.ability.hand_type ~= "None" and context.scoring_name == card.ability.hand_type then
                card.ability.streak = card.ability.streak + 1

                if card.ability.streak < 3 then
                    return {
                        message = card.ability.streak.."/3"
                    }
                end
            end

            if card.ability.streak >= 3 and context.scoring_name == card.ability.hand_type and not context.blueprint then
                card.ability.streak = 0
                card.ability.xmult = card.ability.xmult + 0.25

                return {
                    message = "X"..card.ability.xmult,
                    colour = G.C.MULT
                }
            end

            if card.ability.hand_type ~= "None" and context.scoring_name ~= card.ability.hand_type and not context.blueprint then
                card.ability.hand_type = "None"
                card.ability.streak = 0
                card.ability.xmult = 1

                return {
                    message = localize("k_reset")
                }
            end
        end

        if context.joker_main then
            if card.ability.xmult == 1 then return end

            return {
                xmult = card.ability.xmult
            }
        end
    end
}

-- Collector
SMODS.Joker {
    key = "GG_collector",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 5,

    blueprint_compat = true,

    config = {
        multi = 0,
        multigain = 3,
        used = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_collector",
            vars = {
                card.ability.multigain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local seen = false

            for _, v in ipairs(card.ability.used) do
                if context.other_card:get_id() == v then
                    seen = true
                end
            end

            if not seen then
                card.ability.multi = card.ability.multi + card.ability.multigain
                table.insert(card.ability.used, context.other_card:get_id())
            end
        end

        if context.joker_main then
            local multi = card.ability.multi

            card.ability.used = {}
            card.ability.multi = 0

            return {
                mult = multi
            }
        end
    end
}

-- Wind Vane
SMODS.Joker {
    key = "GG_windvane",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 4,

    blueprint_compat = false,

    config = {
        goodsuit = "Hearts",
        badsuit = "Clubs",
        multi = 0,
        multigain = 1,
        multiloss = 2
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_windvane",
            vars = {
                localize(card.ability.goodsuit),
                localize(card.ability.badsuit),
                card.ability.multi,
                card.ability.multigain,
                card.ability.multiloss
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            local suits = {"Spades", "Hearts", "Clubs", "Diamonds"}
            local goodindex = math.floor(pseudorandom("GG_vwgood") * 4) + 1
            local badindex = math.floor(pseudorandom("GG_vwbad") * 4) + 1

            if goodindex == badindex then
                while true do
                    badindex = math.floor(pseudorandom("GG_vwbad") * 4) + 1

                    if goodindex ~= badindex then
                        break
                    end
                end
            end

            card.ability.goodsuit = suits[goodindex]
            card.ability.badsuit = suits[badindex]
        end

        if context.individual and context.cardarea == G.play and
            not context.blueprint then
            if context.other_card:is_suit(card.ability.goodsuit) then
                card.ability.multi = card.ability.multi + card.ability.multigain
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.RED
                }
            elseif context.other_card:is_suit(card.ability.badsuit) then
                card.ability.multi = card.ability.multi - card.ability.multiloss

                if card.ability.multi < 0 then
                    card.ability.multi = 0
                end

                return {
                    message = localize("d_downgrade"),
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.multi
            }
        end
    end
}

-- Laggy PC
SMODS.Joker {
    key = "GG_laggypc",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 4,

    blueprint_compat = true,

    config = {
        retriggers = 1
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_laggypc",
            vars = {
                G.GAME.probabilities.normal,
                card.ability.retriggers
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and pseudorandom("laggypc") <= G.GAME.probabilities.normal / 3 and next(context.card_effects[1]) then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.retriggers
            }
        end
    end
}

-- Paperclip
SMODS.Joker {
    key = "GG_paperclip",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 5,

    blueprint_compat = true,

    config = {
        multi = 0,
        multigain = 1,
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_paperclip",
            vars = {
                card.ability.multi,
                card.ability.multigain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card == context.scoring_hand[1] then
                card.ability.multi = card.ability.multi + card.ability.multigain

                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.multi
            }
        end
    end
}

-- Broken Mirror
SMODS.Joker {
    key = "GG_brokenmirror",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 4,

    blueprint_compat = true,

    config = {
        lowest = math.huge,
        retriggers = 1
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_brokenmirror",
            vars = {
                card.ability.retriggers
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.lowest = math.huge

            local scoringCards = context.scoring_hand

            for k, v in pairs(scoringCards) do
                if v:get_id() < card.ability.lowest then
                    card.ability.lowest = v:get_id()
                end
            end
        end

        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == card.ability.lowest then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.retriggers
                }
            end
        end
    end
}

-- Math.Random()
SMODS.Joker {
    key = "GG_mathrandom",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 5,

    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_mathrandom",
            vars = {
                G.GAME.probabilities.normal
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom("mathrandom") <= G.GAME.probabilities.normal / 2 then
                return {
                    xmult = 2
                }
            else
                return {
                    xmult = 0.5
                } 
            end 
        end
    end
}

-- Explosive
SMODS.Joker {
    key = "GG_explosive",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = 1,
    cost = 5,

    blueprint_compat = true,

    config = {
        xmult = 3
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_explosive",
            vars = {
                card.ability.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            card:set_debuff(true)
            
            return {
                xmult = card.ability.xmult
            }
        end

        if context.end_of_round and context.main_eval then
            card:set_debuff(false)
        end
    end
}

-- Cantaloupe
SMODS.Joker {
    key = "GG_cantaloupe",
    atlas = "atlasjonklers",
    pos = {
        x = 2,
        y = 0
    },

    rarity = 1,
    cost = 7,

    blueprint_compat = true,

    config = {
        power = 0.1,
        powerloss = 0.01
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_cantaloupe",
            vars = {
                card.ability.power,
                card.ability.powerloss,
                colours = {
                    SMODS.Gradients.GG_C_power
                }
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                power = card.ability.power
            }
        end

        if context.reroll_shop and not context.blueprint then
            card.ability.power = card.ability.power - card.ability.powerloss

            if card.ability.power > math.floor(card.ability.powerloss*100)/100 then
                return {
                    message = "-" .. tostring(card.ability.powerloss) .. " Power",
                    colour = SMODS.Gradients.GG_C_power
                }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card.T.r = -0.2
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))

                return {
                    message = localize("k_eaten_ex")
                }
            end
        end
    end
}

-- Uncommons

-- Seigneur
SMODS.Joker {
    key = "GG_seigneur",
    atlas = "atlasjonklers",
    pos = {
        x = 0,
        y = 1
    },

    soul_pos = {
        x = 0,
        y = 2
    },

    rarity = 2,
    cost = 5,

    blueprint_compat = false,

    config = {
        rounds = 2,
        xmulti = 3,
        moneyearned = 5
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_seigneur",
            vars = {
                card.ability.rounds,
                card.ability.xmulti,
                card.ability.moneyearned
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.xmulti
            }
        end

        if context.end_of_round and context.cardarea == G.jokers then
            if card.ability.rounds > 1 then
                card.ability.rounds = card.ability.rounds - 1

                return {
                    message = tostring(card.ability.rounds)
                }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card.T.r = -0.2
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))

                return {
                    remove_default_message = true,
                    dollars = card.ability.moneyearned,
                    message = localize("d_etoh")
                }
            end
        end
    end
}

-- Uno!!
SMODS.Joker {
    key = "GG_uno",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 6,

    blueprint_compat = true,

    config = {
        chips = 0,
        chipsgain = 3,
        lastcard = "None"
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_uno",
            vars = {
                card.ability.chips,
                card.ability.chipsgain,
                card.ability.lastcard
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if card.ability.lastcard ~= "None" then
                if string.sub(card.ability.lastcard, 1, 1) == string.sub(context.other_card.base.suit, 1, 1) or string.sub(card.ability.lastcard, 2) == tostring(context.other_card.base.id) then
                    if not context.blueprint then
                        card.ability.chips = card.ability.chips + card.ability.chipsgain
                        card.ability.lastcard = string.sub(context.other_card.base.suit, 1, 1) .. context.other_card.base.id
                    end

                    return {
                        message = localize("k_upgrade_ex"),
                        colour = G.C.CHIPS
                    }
                else
                    if card.ability.chips > 0 then
                        card.ability.chips = 0
                        card.ability.lastcard = string.sub(context.other_card.base.suit, 1, 1) .. context.other_card.base.id

                        return {
                            message = localize("k_reset")
                        }
                    end
                end
            elseif card.ability.lastcard == "None" then
                if not context.blueprint then
                    card.ability.chips = card.ability.chips + card.ability.chipsgain
                    card.ability.lastcard = string.sub(context.other_card.base.suit, 1, 1) .. context.other_card.base.id
                end
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.chips
            }
        end
    end
}

-- Percentile
SMODS.Joker {
    key = "GG_percentile",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 7,

    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_percentile"
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local chipsval = hand_chips:to_number()
            local multval = mult:to_number()

            local balance = (chipsval + multval) / math.max(chipsval, multval)
            local balancernd = math.floor(balance * 100) / 100

            return {
                xmult = balancernd
            }
        end
    end
}

-- Taped Egg
SMODS.Joker {
    key = "GG_tapedegg",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 5,
    
    blueprint_compat = true,

    config = {
        broken = false
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = (card.ability.broken and "j_GG_crackedegg" or "j_GG_tapedegg"),
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands["Flush"]) and not card.ability.broken then
            local value = 0

            for k, v in pairs(context.scoring_hand) do
                if v.base.id and v.config.center.key ~= "c_stone" then
                    value = value + v.base.id
                end
            end

            return {
                mult = value
            }
        end

        if context.after and next(context.poker_hands["Flush"]) and not card.ability.broken then
            card.ability.broken = true
            card.ability.blueprint_compat = false

            card.children.center:set_sprite_pos({
                x = 0,
                y = 0
            })

            card:juice_up(0.5,0.2)
            
            return {
                remove_default_message = true,
                message = localize("d_cracked")
            }
        end

        if context.after and #G.play.cards == 1 and G.play.cards[1].base.id == 14 and card.ability.broken then
            card.ability.broken = false
            card.ability.blueprint_compat = true

            card.children.center:set_sprite_pos({
                x = 1,
                y = 0
            })

            card:juice_up(0.5,0.2)

            return {
                message = localize("d_repaired")
            }
        end
    end
}

-- 777
SMODS.Joker {
    key = "GG_777",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 7,

    blueprint_compat = true,

    config = {
        moneyearned = 7,
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_777",
            vars = {
                card.ability.moneyearned
            }
        }
    end,

    calculate = function(self, card, context)
        if context.destroy_card and next(context.poker_hands["Three of a Kind"]) and context.destroy_card ==
            context.full_hand[1] and context.destroy_card:get_id() == 7 then
            return {
                remove = true,
                dollars = card.ability.moneyearned
            }
        end
    end
}

-- Investor
SMODS.Joker {
    key = "GG_investor",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_investor"
        }
    end,

    calc_dollar_bonus = function(self, card)
        local dollars = math.floor(G.GAME.dollars:to_number() / 10)
        local ante = G.GAME.round_resets.blind_ante

        dollars = math.min(dollars, ante * 2)

        return lenient_bignum(dollars)
    end
}

-- Cursed Coin
SMODS.Joker {
    key = "GG_cursedcoin",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 15,

    config = {
        moneyearned = 7,
        xmulti = 0.7
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_cursedcoin",
            vars = {
                card.ability.moneyearned,
                card.ability.xmulti
            }
        }
    end,

    calc_dollar_bonus = function(self, card)
        return lenient_bignum(card.ability.moneyearned)
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.xmulti
            }
        end
    end
}

-- Sine Wave
SMODS.Joker {
    key = "GG_sinewave",
    atlas = "atlasjonklers",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 7,

    blueprint_compat = true,

    config = {
        func = 1
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_sinewave",
            vars = {card.ability.func}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local func = math.floor((math.sin(math.rad(3 * G.hand.config.card_limit)) + 2) * 100) / 100

            return {
                xmult = func
            }
        end
    end,

    update = function(self, card, dt)
        if G.hand then
            card.ability.func = math.floor((math.sin(math.rad(3 * G.hand.config.card_limit)) + 2) * 100) / 100
        end
    end
}

-- Coffin
SMODS.Joker {
    key = "GG_coffin",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 7,

    config = {
        revivesLeft = 3,
        text = "times"
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_coffin",
            vars = {
                card.ability.revivesLeft,
                card.ability.text
            }
        }
    end,

    calculate = function(self, card, context)
        if context.game_over then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound("tarot1")
                    
                    if card.ability.revivesLeft <= 0 then
                        card:start_dissolve()
                    end

                    return true
                end
            }))
            
            card.ability.revivesLeft = card.ability.revivesLeft - 1
            ease_dollars(-G.GAME.dollars:to_number())

            if card.ability.revivesLeft == 1 then
                card.ability.text = "time"
            end

            local msg = card.ability.revivesLeft > 0 and tostring(card.ability.revivesLeft) or localize("d_no_revives_left")

            return {
                message = msg,
                saved = true
            }
        end
    end
}

-- Engineer's Cap
SMODS.Joker {
    key = "GG_engineerscap",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 8,

    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_engineerscap",
            vars = {
                G.GAME.probabilities.normal
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before then
            local set = false
            
            for k, v in pairs(context.scoring_hand) do
                if v.base.id >= 2 and v.base.id <= 10 and pseudorandom("engineerscap") <= G.GAME.probabilities.normal / 4 then
                    v:set_ability("m_steel")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                    set = true
                end
            end

            if set then
                return {
                    message = localize("d_steel"),
                    colour = HEX("d4deef")
                }
            end
        end
    end
}

-- Citadel
SMODS.Joker {
    key = "GG_citadel",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 7,

    blueprint_compat = true,

    config = {
        xmult = 1,
        xmultgain = 0.03
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_citadel",
            vars = {
                card.ability.xmult,
                card.ability.xmultgain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.xmult = card.ability.xmult + card.ability.xmultgain

            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.RED
            }
        end

        if context.joker_main then
            return {
                xmult = card.ability.xmult
            }
        end
    end
}

-- Rares

-- Blackjack
SMODS.Joker {
    key = "GG_blackjack",
    atlas = "atlasholders",
    pos = {
        x = 2,
        y = 0
    },

    rarity = 3,
    cost = 10,

    blueprint_compat = true,

    config = {
        xmulti21 = 3,
        xmultig21 = 0.9
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_blackjack",
            vars = {
                card.ability.xmulti21,
                card.ability.xmultig21
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local total = 0

            for i = 1, #G.play.cards do
                if G.play.cards[i].base.id == 11 or G.play.cards[i].base.id == 12 or G.play.cards[i].base.id == 13 then
                    total = total + 10
                elseif G.play.cards[i].base.id == 14 then
                    total = total + 11
                else
                    total = total + G.play.cards[i].base.id
                end
            end

            if total < 21 then
                return {
                    remove_default_message = true,
                    mult = total,
                    message = tostring(total)
                }
            elseif total == 21 then
                return {
                    remove_default_message = true,
                    xmult = card.ability.xmulti21,
                    message = tostring(total * card.ability.xmulti21)
                }
            else
                return {
                    remove_default_message = true,
                    xmult = card.ability.xmultig21,
                    message = tostring(total * card.ability.xmultig21)
                }
            end
        end
    end
}

-- Power Cell
SMODS.Joker {
    key = "GG_powercell",
    atlas = "atlasholders",
    pos = {
        x = 2,
        y = 0
    },

    rarity = 3,
    cost = 10,

    blueprint_compat = true,

    config = {
        power = 0,
        powergain = 0.05,
        powermax = 0.5
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_powercell",
            vars = {
                card.ability.power,
                card.ability.powergain,
                card.ability.powermax,
                colours = {
                    SMODS.Gradients.GG_C_power
                }
            }
        }
    end,

    calculate = function(self, card, context)
        if context.pre_discard and card.ability.power < card.ability.powermax and not context.blueprint then
            card.ability.power = card.ability.power + card.ability.powergain

            return {
                message = localize("k_upgrade_ex"),
                colour = SMODS.Gradients.GG_C_power
            }
        end

        if context.joker_main then
            if #context.scoring_hand == 5 then
                local storedpower = card.ability.power

                card.ability.power = 0

                return {
                    power = storedpower
                }
            end
        end
    end
}

-- Jonkler
SMODS.Joker {
    key = "GG_jonkler",
    atlas = "atlasholders",
    pos = {
        x = 2,
        y = 0
    },

    rarity = 3,
    cost = 10,

    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_jonkler"
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                swap = true,
                remove_default_message = true,
                message = localize("d_swapped")
            }
        end
    end
}

-- Little
SMODS.Joker {
    key = "GG_little",
    atlas = "atlasholders",
    pos = {
        x = 2,
        y = 0
    },

    rarity = 3,
    cost = 10,

    blueprint_compat = true,

    config = {
        xchips = 1,
        xchipsgain = 0.2,
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_little",
            vars = {
                card.ability.xchips,
                card.ability.xchipsgain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xchips = card.ability.xchips
            }
        end

        if context.remove_playing_cards and not context.blueprint then
            for k, v in pairs(context.removed) do
                card.ability.xchips = card.ability.xchips + card.ability.xchipsgain
            end

            return {
                message = "X"..card.ability.xchips,
                colour = G.C.CHIPS
            }
        end
    end
}

-- Bucket
SMODS.Joker {
    key = "GG_bucket",
    atlas = "atlasjonklers",
    pos = {
        x = 1,
        y = 1
    },

    soul_pos = {
        x = 1,
        y = 2
    },

    rarity = 3,
    cost = 10,

    blueprint_compat = true,

    config = {
        xpower = 1,
        xpowergain = 0.02
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_bucket",
            vars = {
                colours = {
                    SMODS.Gradients.GG_C_power
                },
                card.ability.xpower,
                card.ability.xpowergain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.xpower = card.ability.xpower + card.ability.xpowergain

            return {
                message = localize("k_upgrade_ex"),
                colour = SMODS.Gradients.GG_C_power
            }
        end
        
        if context.joker_main and card.ability.xpower > 1 then
            return {
                xpower = card.ability.xpower
            }
        end
    end
}

-- Stopwatch
SMODS.Joker {
    key = "GG_stopwatch",
    atlas = "atlasholders",
    pos = {
        x = 2,
        y = 0
    },

    rarity = 3,
    cost = 10,

    config = {
        handsinc = 0,
        discardsinc = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_stopwatch",
            vars = {
                card.ability.handsinc,
                card.ability.discardsinc
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local hands_inc = G.GAME.current_round.hands_left
            local discards_inc = G.GAME.current_round.discards_left
            
            if hands_inc > G.GAME.round_resets.hands / 2 then
                hands_inc = G.GAME.round_resets.hands / 2
            end

            if discards_inc > G.GAME.round_resets.discards / 2 then
                discards_inc = G.GAME.round_resets.discards / 2
            end

            card.ability.handsinc = hands_inc
            card.ability.discardsinc = discards_inc
        end

        if context.setting_blind and not (context.blueprint_card or card).getting_sliced then
            ease_hands_played(card.ability.handsinc)
            ease_discard(card.ability.discardsinc)
        end
    end
}

-- Legendaries

-- Brimstone
SMODS.Joker {
    key = "GG_brimstone",
    atlas = "atlasjonklers",
    pos = {
        x = 3,
        y = 0
    },

    soul_pos = {
        x = 4,
        y = 0
    },

    rarity = 4,
    cost = 20,

    config = {
        maxmult = 10,
        xmult = 9
    },

    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_brimstone",
            vars = {
                card.ability.maxmult,
                card.ability.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local calcTable = {
                {
                    mult = {
                        eval = true,
                        vars = {},
                        func = function(vars)
                            return {
                                math.floor(pseudorandom("GG_brimstone") * card.ability.maxmult) + 1
                            }
                        end
                    },
                    repeats = 10
                },

                {
                    xmult = card.ability.xmult
                }
            }

            local table = CalcLib.combine_calculate(calcTable)
            
            return table
        end
    end
}

-- Miscellaneous

local function text_randomise(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""

    for i = 1, length do
        local char = math.random(1, #chars)
        result = result .. chars:sub(char, char)
    end

    return result
end

-- Corrupted
SMODS.Joker {
    key = "GG_corrupted",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 0
    },

    rarity = "GG_miscellaneous",
    cost = 1,

    config = {
        name = text_randomise(14),
        active_context = "",
        active_calculation = "",
        passive_contexts = {},
        passive_calculations = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_GG_corrupted",
            vars = {
                card.ability.name
            }
        }
    end,

    no_collection = true,

    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced and (card.ability.active_context == "" and card.ability.active_calculation == "") then
            -- 1 active
            -- 3 passive
            
            -- actives: joker_main or individual
            -- passives: a lot more fun, hand played, discarded, booster opened, with many other passive effects

            -- save my soul lol
            
            local actives = {
                "joker_main",
                "individual"
            }

            local passives = {
                "before",
                "after",
                "end_of_round",
                "setting_blind",
                "pre_discard",
                "open_booster",
                "skipping_booster",
                "buying_card",
                "selling_card",
                "first_hand_drawn",
                "other_drawn",
                "using_consumeable",
                "skip_blind",
                "playing_card_added",
                "card_added",
                "modify_ante",
                "ante_change",
                "discard"
            }

            -- Balatro cannot save functions (sad), so im saving references instead

            local active_calc_ref = {
                "chips",
                "mult",
                "power"
            }

            local active_mult_ref = {
                "xchips",
                "xmult",
                "xpower"
            }

            local passive_calc_ref = {
                "dollars",
                "leveling_up_last"
            }

            -- Now for the actual joker bit oh my god

            local active_context = CalcLib.get_random_items(actives, 1, "GG_corrupted")
            local active_calculation = CalcLib.get_random_items(active_calc_ref, 1, "GG_corrupted")

            if pseudorandom("GG_corrupted") < 0.2 then
                active_calculation = CalcLib.get_random_items(active_mult_ref, 1, "GG_corrupted")
            end

            card.ability.active_context = active_context[1]
            card.ability.active_calculation = active_calculation[1]
        end

        if context[card.ability.active_context] then
            if context.individual and context.cardarea ~= G.play then return end

            local active_calc = {
                chips = {
                    chips = {
                        eval = true,
                        vars = {},
                        func = function(vars)
                            return {
                                math.floor(pseudorandom("GG_corrupted") * 15 + 0.999999) + 5
                            }
                        end
                    }
                },

                mult = {
                    mult = {
                        eval = true,
                        vars = {},
                        func = function(vars)
                            return {
                                math.floor(pseudorandom("GG_corrupted") * 5 + 0.999999) + 1
                            }
                        end
                    }
                },

                power = {
                    power = math.floor(pseudorandom("GG_corrupted") + 0.999999) / 20
                },

                xchips = {
                    xchips = math.floor(pseudorandom("GG_corrupted") * 100) / 10 + 1
                },

                xmult = {
                    xmult = math.floor(pseudorandom("GG_corrupted") * 100) / 10 + 1
                },

                xpower = {
                    xpower = math.floor(pseudorandom("GG_corrupted") * 100) / 20 + 1
                },
            }

            local passive_calc = {
                dollars = function()
                    ease_dollars(math.floor(pseudorandom("GG_corrupted") * 4 + 0.999999) + 1)
                end,

                leveling_up_last = function()

                end
            }

            local active_table = {}

            active_table[#active_table + 1] = active_calc[card.ability.active_calculation]

            active_table = CalcLib.combine_calculate(active_table)

            return active_table
        end
    end,

    update = function(self, card, dt)
        card.ability.name = text_randomise(14)
    end
}
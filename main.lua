GG = SMODS.current_mod

GG.optional_features = {
	retrigger_joker = true,
	post_trigger = true,
	quantum_enhancements = false
}

GG.atlases = {
    jokers = SMODS.Atlas({
        key = "atlasjonklers",
        path = "AtlasJonklers.png",
        px = 71,
        py = 95
    }):register(),

    enhancements = SMODS.Atlas({
        key = "atlasenhancements",
        path = "AtlasEnhancements.png",
        px = 71,
        py = 95
    }):register(),

    decks = SMODS.Atlas({
        key = "atlasdecks",
        path = "AtlasDecks.png",
        px = 71,
        py = 95
    }):register(),

    stakes = SMODS.Atlas({
        key = "atlasstakes",
        path = "AtlasStakes.png",
        px = 29,
        py = 29
    }):register(),

    stickers = SMODS.Atlas({
        key = "atlasstickers",
        path = "AtlasStickers.png",
        px = 71,
        py = 95
    }):register(),

    placeholders = SMODS.Atlas({
        key = "atlasholders",
        path = "AtlasPlaceholders.png",
        px = 71,
        py = 95
    }):register()
}

assert(SMODS.load_file("additions/jokers.lua"))()
assert(SMODS.load_file("additions/tarots.lua"))()
assert(SMODS.load_file("additions/planets.lua"))()
assert(SMODS.load_file("additions/spectrals.lua"))()
assert(SMODS.load_file("additions/sigils.lua"))()
assert(SMODS.load_file("additions/enhancements.lua"))()
assert(SMODS.load_file("additions/packs.lua"))()
assert(SMODS.load_file("additions/vouchers.lua"))()
assert(SMODS.load_file("additions/decks.lua"))()
assert(SMODS.load_file("additions/stakes.lua"))()
assert(SMODS.load_file("additions/stickers.lua"))()

SMODS.Gradient {
    key = "C_cspecial1",
    colours = {
        mix_colours(G.C.BLACK, G.C.MONEY, 0.9),
        mix_colours(G.C.BLACK, G.C.MONEY, 0.7),
        cycle = 19,
        interpolation = "trig"
    }
}

SMODS.Gradient {
    key = "C_cspecial2",
    colours = {
        mix_colours(G.C.L_BLACK, G.C.MONEY, 0.9),
        mix_colours(G.C.L_BLACK, G.C.MONEY, 0.7),
        cycle = 10,
        interpolation = "trig"
    }
}

SMODS.Gradient {
    key = "C_power",
    colours = {
        mix_colours(G.C.PURPLE, G.C.RED, 0.8),
        mix_colours(G.C.PURPLE, G.C.BLUE, 0.8),
        cycle = 10,
        interpolation = "trig"
    }
}

SMODS.Scoring_Parameter {
    key = "GG_power",
    default_value = 1,
    colour = SMODS.Gradients.GG_C_power,

    calculation_keys = {"power", "xpower"},

    hands = {
        ["Flush Five"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.05,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Flush House"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.05,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Five of a Kind"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.04,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Straight Flush"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.04,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Four of a Kind"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.03,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Full House"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.02,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Flush"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.02,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Straight"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.02,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Three of a Kind"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.02,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Two Pair"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.01,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["Pair"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.01,
            ["s_" .. GG.prefix .. "_power"] = 1
        },
        ["High Card"] = {
            [GG.prefix .. "_power"] = 1,
            ["l_" .. GG.prefix .. "_power"] = 0.01,
            ["s_" .. GG.prefix .. "_power"] = 1
        }
    },

    calc_effect = function(self, effect, scored_card, key, amount, from_edition)
        if not SMODS.Calculation_Controls.chips then
            return
        end
        if key == "power" and amount then
            if effect.card and effect.card ~= scored_card then
                juice_card(effect.card)
            end
            self:modify(amount)
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = "+" .. amount .. " Power",
                colour = self.colour
            })
            return true
        end
        if key == "xpower" and amount then
            if effect.card and effect.card ~= scored_card then
                juice_card(effect.card)
            end
            self:modify((self.current - 1) * (amount - 1))
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = "X" .. amount .. " Power",
                colour = self.colour
            })
            return true
        end
    end
}

SMODS.Scoring_Calculation {
    key = "GG_powerCalc",

    func = function(self, chips, mult, flames)
        if type(SMODS.get_scoring_parameter(GG.prefix .. "_power")) == "table" or type(SMODS.get_scoring_parameter(GG.prefix .. "_power")) == "number" then
            return chips * mult ^ (SMODS.get_scoring_parameter(GG.prefix .. "_power") or 1) 
        else 
            return chips * mult ^ 1 
        end
    end,

    parameters = {"chips", "mult", GG.prefix .. "_power"},

    replace_ui = function(self)
        local scale = 0.3
        return {
            n = G.UIT.R,
            config = {
                align = "cm",
                minh = 1,
                padding = 0.1
            },
            nodes = {{
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    id = 'hand_chips'
                },
                nodes = {SMODS.GUI.score_container({
                    type = 'chips',
                    text = 'chip_text',
                    align = 'cm',
                    w = 1.1,
                    scale = scale
                })}
            }, SMODS.GUI.operator(scale * 0.75), {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    id = 'hand_mult'
                },
                nodes = {SMODS.GUI.score_container({
                    type = 'mult',
                    align = 'cm',
                    w = 1.1,
                    scale = scale
                })}
            }, {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    id = 'hand_operator_container'
                },
                nodes = {{
                    n = G.UIT.T,
                    config = {
                        text = '^',
                        lang = G.LANGUAGES['en-us'],
                        scale = scale * 1.5,
                        colour = SMODS.Gradients.GG_C_power,
                        shadow = true
                    }
                }}
            }, {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    id = 'hand_GG_power'
                },
                nodes = {SMODS.GUI.score_container({
                    type = 'GG_power',
                    align = 'cm',
                    w = 1.1,
                    scale = scale
                })}
            }}
        }
    end
}

SMODS.Rarity {
    key = "miscellaneous",
    loc_txt = {
        name = "Miscellaneous"
    },

    pools = {
        ["miscellaneous_pool"] = true
    },

    badge_colour = HEX("3e3e3e"),
    default_weight = 0
}

SMODS.ObjectType {
    key = "miscellaneous_pool",
    cards = {
        ["gg_corrupted"] = true
    }
}

-- Credits UI that I spent like 1 hour on

local GGtabs = function()
	return {
		{
			label = "Credits",
			tab_definition_function = function()
				local ideas = {
                    n = G.UIT.R,
                    config = {
                        colour = G.C.L_BLACK,
                        align = "cl",
                        minw = 9.7,
                        minh = 1.9,
                        r = 0.15,
                        padding = 0.15
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Ideas",
                                colour = G.C.BLACK,
                                vert = true,
                                scale = 0.4,
                                padding = 0.15,
                                align = "cm",
                                minw = 2.8,
                                minh = 1.5,
                                r = 0.15
                            }
                        },

                        {
                            n = G.UIT.B,
                            config = {
                                colour = G.C.L_BLACK,
                                w = 0.5,
                                h = 1.5
                            }
                        }
                    }
                }

                local art = {
                    n = G.UIT.R,
                    config = {
                        colour = G.C.L_BLACK,
                        align = "cl",
                        minw = 9.7,
                        minh = 1.9,
                        r = 0.15,
                        padding = 0.15
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Art",
                                colour = G.C.BLACK,
                                vert = true,
                                scale = 0.4,
                                padding = 0.15,
                                align = "cm",
                                minw = 2.8,
                                minh = 1.5,
                                r = 0.15,
                            }
                        },

                        {
                            n = G.UIT.B,
                            config = {
                                colour = G.C.L_BLACK,
                                w = 0.5,
                                h = 1.5
                            }
                        }
                    }
                }

                local code = {
                    n = G.UIT.R,
                    config = {
                        colour = G.C.L_BLACK,
                        align = "cl",
                        minw = 9.7,
                        minh = 1.9,
                        r = 0.15,
                        padding = 0.15
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Code",
                                colour = G.C.BLACK,
                                vert = true,
                                scale = 0.4,
                                padding = 0.15,
                                align = "cm",
                                minw = 2.8,
                                minh = 1.5,
                                r = 0.15,
                            }
                        },

                        {
                            n = G.UIT.B,
                            config = {
                                colour = G.C.L_BLACK,
                                w = 0.5,
                                h = 1.5
                            }
                        }
                    }
                }

                local special = {
                    n = G.UIT.R,
                    config = {
                        colour = SMODS.Gradients.GG_C_cspecial2,
                        align = "cl",
                        minw = 9.7,
                        minh = 1.9,
                        r = 0.15,
                        padding = 0.15
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Coolios",
                                colour = SMODS.Gradients.GG_C_cspecial1,
                                vert = true,
                                scale = 0.4,
                                align = "cm",
                                minw = 2.8,
                                minh = 1.5,
                                r = 0.15,
                            }
                        },

                        {
                            n = G.UIT.B,
                            config = {
                                colour = SMODS.Gradients.GG_C_cspecial2,
                                w = 0.5,
                                h = 1.5
                            }
                        }
                    }
                }

                local allocs = {
                    {
                        name = localize("c_chemn"),
                        flavour = localize("c_chemd"),
                        loc = "ideas"
                    },

                    {
                        name = localize("c_frostn"),
                        flavour = localize("c_frostd"),
                        loc = "ideas"
                    },

                    {
                        name = localize("c_frostn"),
                        flavour = localize("c_frostd"),
                        loc = "art"
                    },

                    {
                        name = localize("c_sein"),
                        flavour = localize("c_seid"),
                        loc = "ideas"
                    },

                    {
                        name = localize("c_ysfn"),
                        flavour = localize("c_ysfd"),
                        loc = "ideas"
                    },

                    {
                        name = localize("c_agun"),
                        flavour = localize("c_agud"),
                        loc = "ideas"
                    },

                    {
                        name = localize("c_gn"),
                        flavour = localize("c_gd"),
                        loc = "art"
                    },

                    {
                        name = localize("c_gn"),
                        flavour = localize("c_gd"),
                        loc = "code"
                    },

                    {
                        name = localize("sc_eremeln"),
                        flavour = localize("sc_eremeld"),
                        loc = "special"
                    },

                    {
                        name = localize("sc_communityn"),
                        flavour = localize("sc_communityd"),
                        loc = "special"
                    }
                }

                for i, alloc in ipairs(allocs) do
                    local node_type = nil
                    local alloc_back = G.C.BLACK

                    -- Stupid implementation by me :D
                    if alloc.loc == "ideas" then
                        node_type = ideas.nodes
                    elseif alloc.loc == "art" then
                        node_type = art.nodes
                    elseif alloc.loc == "code" then
                        node_type = code.nodes
                    elseif alloc.loc == "special" then
                        node_type = special.nodes
                        alloc_back = SMODS.Gradients.GG_C_cspecial1
                    end

                    node_type[#node_type + 1] = {
                        n = G.UIT.C,
                        config = {
                            colour = alloc_back,
                            align = "tm",
                            minw = 2.1,
                            minh = 1.5,
                            r = 0.15,
                            padding = 0.15
                        },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = {
                                    colour = alloc_back,
                                    align = "tm",
                                    minw = 2.1,
                                    minh = 0.5,
                                    r = 0.15,
                                    padding = 0.15
                                },
                                nodes = {
                                    {
                                        n = G.UIT.O,
                                        config = {
                                            object = DynaText({
                                                string = alloc.name,
                                                colours = { G.C.WHITE },
                                                shadow = true,
                                                scale = 0.4,
                                            }),
                                            padding = 0.15,
                                            align = "cm",
                                            maxw = 2.1,
                                            maxh = 1.2,
                                            r = 0.15
                                        }
                                    }
                                }
                            },

                            {
                                n = G.UIT.R,
                                config = {
                                    colour = alloc_back,
                                    align = "bm",
                                    minw = 2.1,
                                    minh = 0.5,
                                    r = 0.15,
                                    padding = 0.15
                                },
                                nodes = {
                                    {
                                        n = G.UIT.O,
                                        config = {
                                            object = DynaText({
                                                string = alloc.flavour,
                                                colours = { G.C.WHITE },
                                                shadow = true,
                                                scale = 0.3,
                                            }),
                                            padding = 0.15,
                                            align = "cm",
                                            maxw = 2.1,
                                            maxh = 1.2,
                                            r = 0.15
                                        }
                                    }
                                }
                            }
                        }
                    }
                end

                local nodes = {}

                nodes[#nodes + 1] = ideas
                nodes[#nodes + 1] = art
                nodes[#nodes + 1] = code
                nodes[#nodes + 1] = special

				return {
					n = G.UIT.ROOT,
					config = {
						emboss = 0.05,
						minh = 6,
						r = 0.1,
						minw = 10,
						align = "cm",
						padding = 0.2,
						colour = G.C.BLACK,
					},
					nodes = nodes,
				}
			end,
		},
	}
end

GG.extra_tabs = GGtabs

-- Not used yet :sob:

--[[G.FUNCS = G.FUNCS or {}

G.FUNCS.can_freeze = function(e)
    if not e or not e.config then return false end
    if not G.shop_freeze then return false end
    if not G.shop_freeze.cards then G.shop_freeze.cards = {} end
    if not G.GAME or not G.GAME.starting_params then return false end
    
    local max_cards = G.GAME.starting_params.freeze_max or 1
    if #G.shop_freeze.cards >= max_cards then return false end
    
    local card = e.config.ref_table
    if not card then return false end
    if not card.is or not card:is(Card) then return false end
    if card.freeze_timer and card.freeze_timer > 0 then return false end
    
    if not card.area or card.area.config.type ~= 'shop' then return false end
    
    local is_joker = card.config and card.config.center and card.config.center.set == 'Joker'
    local is_consumable = card.ability and card.ability.consumeable
    if not (is_joker or is_consumable) then return false end
    
    return true
end

G.FUNCS.freeze = function(e)
    local c1 = e.config.ref_table
    if not (c1 and c1:is(Card)) then return false end
    if not G.shop_freeze then return false end
    
    --if #G.shop_freeze.cards >= (G.GAME.starting_params.freeze_max or 1) then
    --    attention_text({ text = localize('k_no_room_ex'), scale = 0.6 })
    --    return false
    --end

    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.05, func = function()
        if G.GAME.current_round.frozen_card and G.GAME.current_round.frozen_card ~= "MANUAL_REPLACE" then
            G.GAME.current_round.frozen_card:add_to_deck()
            
            G.shop_freeze:emplace(G.GAME.current_round.frozen_card)
        else
            if c1.children.freeze_button then c1.children.freeze_button:remove() end
            c1.children.freeze_button = nil
            remove_nils(c1.children)

            if c1.area then c1.area:remove_card(c1) end
            G.shop_freeze:emplace(c1)
            G.GAME.current_round.frozen_card = c1 
        end

        c1.frozen_from_shop = true
        c1.freeze_timer = G.GAME.starting_params.freeze_time or 3
        
        play_sound('card1')
        return true
    end }))
    return true
end]]

-- Hooks

local game_start_run_ref = Game.start_run
local g_uidef_shop_ref = G.UIDEF.shop
local add_round_eval_row_ref = add_round_eval_row

function Game:start_run(args)
    game_start_run_ref(self, args)

    SMODS.set_scoring_calculation("GG_powerCalc")
end

function G.UIDEF.shop()
    local ui = g_uidef_shop_ref()
    local loc = ui.nodes[1].nodes[1].nodes[1].nodes[1].nodes[1].nodes

    G.shop_freeze = CardArea(G.hand.T.x + 0, G.hand.T.y + G.ROOM.T.y + 9, 1.02 * G.CARD_W, 1.05 * G.CARD_H, {
        card_limit = 1,
        type = "shop",
        highlight_limit = 1
    })

    local freeze_ui = {
        n = G.UIT.C,
        config = {
            align = "cm",
            padding = 0.15,
            r = 0.2,
            colour = HEX("3cb0b5"),
            emboss = 0.05
        },
        nodes = {{
            n = G.UIT.C,
            config = {
                align = "cm",
                padding = 0.2,
                r = 0.2,
                colour = HEX("63e3e8"),
                emboss = 0.05,
                minw = 3,
                maxw = 3
            },
            nodes = {{
                n = G.UIT.T,
                config = {
                    text = G.GAME.starting_params.freeze_time ~= nil and G.GAME.starting_params.freeze_time or localize("d_freeze"),
                    scale = 0.45,
                    colour = HEX("3cb0b5"),
                    vert = true
                }}, {
                n = G.UIT.O,
                config = {
                    object = G.shop_freeze
                }
            }}
        }}
    }

    loc[2].config = {
        align = "cm",
        padding = 0.2,
        r = 0.2,
        emboss = 0.05,
        colour = G.C.L_BLACK,
        --maxh = G.shop_jokers.T.h + 0.4
    }
    loc[#loc + 1] = freeze_ui

    G.HUD:recalculate()

    return ui
end

function add_round_eval_row(config)
    local saved_texts = {
        localize("d_saved1"),
        localize("d_saved2"),
        localize("d_saved3"),
        localize("d_saved4"),
        localize("d_saved5"),
        localize("d_saved6"),
        localize("d_saved7"),
        localize("d_saved8"),
        localize("d_saved9"),
        localize("d_saved10"),
    }

    G.GAME.saved_text = saved_texts[math.random(1, #saved_texts)]

    add_round_eval_row_ref(config)
end
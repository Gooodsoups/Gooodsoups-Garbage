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

    placeholders = SMODS.Atlas({
        key = "atlasholders",
        path = "AtlasPlaceholders.png",
        px = 71,
        py = 95
    }):register()
}

assert(SMODS.load_file("additions/jokers.lua"))()
assert(SMODS.load_file("additions/consumeables.lua"))()
assert(SMODS.load_file("additions/enhancements.lua"))()
assert(SMODS.load_file("additions/packs.lua"))()
assert(SMODS.load_file("additions/vouchers.lua"))()
assert(SMODS.load_file("additions/decks.lua"))()

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
    default_value = 0,
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

--Home 17 song is cool

-- How does this bs work

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

-- Freeze fucktion that doesn't even work

function G.UIDEF.shop()
    G.shop_jokers = CardArea(G.hand.T.x + 0, G.hand.T.y + G.ROOM.T.y + 9, 1.02 * G.CARD_W + 2, 1.05 * G.CARD_H, {
        card_limit = G.GAME.shop.joker_max,
        type = 'shop',
        highlight_limit = 1
    })

    G.shop_freeze = CardArea(G.hand.T.x + 0, G.hand.T.y + G.ROOM.T.y + 9, 1.02 * G.CARD_W, 1.05 * G.CARD_H, {
        card_limit = 1,
        type = "shop",
        highlight_limit = 1
    })

    G.shop_vouchers = CardArea(G.hand.T.x + 0, G.hand.T.y + G.ROOM.T.y + 9, 2.1 * G.CARD_W, 1.05 * G.CARD_H, {
        card_limit = 1,
        type = 'shop',
        highlight_limit = 1
    })

    G.shop_booster = CardArea(G.hand.T.x + 0, G.hand.T.y + G.ROOM.T.y + 9, 2.4 * G.CARD_W, 1.15 * G.CARD_H, {
        card_limit = 2,
        type = 'shop',
        highlight_limit = 1,
        card_w = 1.27 * G.CARD_W
    })

    local shop_sign = AnimatedSprite(0, 0, 4.4, 2.2, G.ANIMATION_ATLAS['shop_sign'])
    shop_sign:define_draw_steps({{
        shader = 'dissolve',
        shadow_height = 0.05
    }, {
        shader = 'dissolve'
    }})
    G.SHOP_SIGN = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                colour = G.C.DYN_UI.MAIN,
                emboss = 0.05,
                align = 'cm',
                r = 0.1,
                padding = 0.1
            },
            nodes = {{
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.1,
                    minw = 4.72,
                    minh = 3.1,
                    colour = G.C.DYN_UI.DARK,
                    r = 0.1
                },
                nodes = {{
                    n = G.UIT.R,
                    config = {
                        align = "cm"
                    },
                    nodes = {{
                        n = G.UIT.O,
                        config = {
                            object = shop_sign
                        }
                    }}
                }, {
                    n = G.UIT.R,
                    config = {
                        align = "cm"
                    },
                    nodes = {{
                        n = G.UIT.O,
                        config = {
                            object = DynaText({
                                string = {localize('ph_improve_run')},
                                colours = {lighten(G.C.GOLD, 0.3)},
                                shadow = true,
                                rotate = true,
                                float = true,
                                bump = true,
                                scale = 0.5,
                                spacing = 1,
                                pop_in = 1.5,
                                maxw = 4.3
                            })
                        }
                    }}
                }}
            }}
        },
        config = {
            align = "cm",
            offset = {
                x = 0,
                y = -15
            },
            major = G.HUD:get_UIE_by_ID('row_blind'),
            bond = 'Weak'
        }
    }
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            G.SHOP_SIGN.alignment.offset.y = 0
            return true
        end)
    }))
    local t = {
        n = G.UIT.ROOT,
        config = {
            align = 'cl',
            colour = G.C.CLEAR
        },
        nodes = {UIBox_dyn_container({{
            n = G.UIT.C,
            config = {
                align = "cm",
                padding = 0.1,
                emboss = 0.05,
                r = 0.1,
                colour = G.C.DYN_UI.BOSS_MAIN
            },
            nodes = {{
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.05
                },
                nodes = {{
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.1
                    },
                    nodes = {{
                        n = G.UIT.R,
                        config = {
                            id = 'next_round_button',
                            align = "cm",
                            minw = 2.8,
                            minh = 1.5,
                            r = 0.15,
                            colour = G.C.RED,
                            one_press = true,
                            button = 'toggle_shop',
                            hover = true,
                            shadow = true
                        },
                        nodes = {{
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                padding = 0.07,
                                focus_args = {
                                    button = 'y',
                                    orientation = 'cl'
                                },
                                func = 'set_button_pip'
                            },
                            nodes = {{
                                n = G.UIT.R,
                                config = {
                                    align = "cm",
                                    maxw = 1.3
                                },
                                nodes = {{
                                    n = G.UIT.T,
                                    config = {
                                        text = localize('b_next_round_1'),
                                        scale = 0.4,
                                        colour = G.C.WHITE,
                                        shadow = true
                                    }
                                }}
                            }, {
                                n = G.UIT.R,
                                config = {
                                    align = "cm",
                                    maxw = 1.3
                                },
                                nodes = {{
                                    n = G.UIT.T,
                                    config = {
                                        text = localize('b_next_round_2'),
                                        scale = 0.4,
                                        colour = G.C.WHITE,
                                        shadow = true
                                    }
                                }}
                            }}
                        }}
                    }, {
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            minw = 2.8,
                            minh = 1.6,
                            r = 0.15,
                            colour = G.C.GREEN,
                            button = 'reroll_shop',
                            func = 'can_reroll',
                            hover = true,
                            shadow = true
                        },
                        nodes = {{
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                padding = 0.07,
                                focus_args = {
                                    button = 'x',
                                    orientation = 'cr'
                                },
                                func = 'set_button_pip'
                            },
                            nodes = {{
                                n = G.UIT.R,
                                config = {
                                    align = "cm",
                                    maxw = 1.3
                                },
                                nodes = {{
                                    n = G.UIT.T,
                                    config = {
                                        text = localize('k_reroll'),
                                        scale = 0.4,
                                        colour = G.C.WHITE,
                                        shadow = true
                                    }
                                }}
                            }, {
                                n = G.UIT.R,
                                config = {
                                    align = "cm",
                                    maxw = 1.3
                                },
                                nodes = {{
                                    n = G.UIT.T,
                                    config = {
                                        text = localize('$'),
                                        scale = 0.7,
                                        colour = G.C.WHITE,
                                        shadow = true
                                    }
                                }, {
                                    n = G.UIT.T,
                                    config = {
                                        ref_table = G.GAME.current_round,
                                        ref_value = 'reroll_cost',
                                        scale = 0.75,
                                        colour = G.C.WHITE,
                                        shadow = true
                                    }
                                }}
                            }}
                        }}
                    }}
                }, {
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.2,
                        r = 0.2,
                        emboss = 0.05,
                        colour = G.C.L_BLACK,
                        maxh = G.shop_jokers.T.h + 0.4
                    },
                    nodes = {{
                        n = G.UIT.O,
                        config = {
                            object = G.shop_jokers
                        }
                    }}
                }, {
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
                }}
            }, {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    minh = 0.2
                },
                nodes = {}
            }, {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.1
                },
                nodes = {{
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.15,
                        r = 0.2,
                        colour = G.C.L_BLACK,
                        emboss = 0.05
                    },
                    nodes = {{
                        n = G.UIT.C,
                        config = {
                            align = "cm",
                            padding = 0.2,
                            r = 0.2,
                            colour = G.C.BLACK,
                            maxh = G.shop_vouchers.T.h + 0.4
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize {
                                    type = 'variable',
                                    key = 'ante_x_voucher',
                                    vars = {G.GAME.round_resets.ante}
                                },
                                scale = 0.45,
                                colour = G.C.L_BLACK,
                                vert = true
                            }
                        }, {
                            n = G.UIT.O,
                            config = {
                                object = G.shop_vouchers
                            }
                        }}
                    }}
                }, {
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.15,
                        r = 0.2,
                        colour = G.C.L_BLACK,
                        emboss = 0.05
                    },
                    nodes = {{
                        n = G.UIT.O,
                        config = {
                            object = G.shop_booster
                        }
                    }}
                }}
            }}
        }}, false)}
    }
    
    G.HUD:recalculate()

    return t
end

-- I got bored and couldn't be asked to make jokers that change the revive text

function add_round_eval_row(config)
    local config = config or {}
    local width = G.round_eval.T.w - 0.51
    local num_dollars = config.dollars or 1
    local scale = 0.9

    if config.name ~= 'bottom' then
        total_cashout_rows = (total_cashout_rows or 0) + 1
        if total_cashout_rows > 7 then
            return
        end
        if config.name ~= 'blind1' then
            if not G.round_eval.divider_added then 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',delay = 0.25,
                    func = function() 
                        local spacer = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
                            {n=G.UIT.O, config={object = DynaText({string = {'......................................'}, colours = {G.C.WHITE},shadow = true, float = true, y_offset = -30, scale = 0.45, spacing = 13.5, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
                        }}
                        G.round_eval:add_child(spacer,G.round_eval:get_UIE_by_ID(config.bonus and 'bonus_round_eval' or 'base_round_eval'))
                        return true
                    end
                }))
                delay(0.6)
                G.round_eval.divider_added = true
            end
        else
            delay(0.2)
        end

        delay(0.2)

        G.E_MANAGER:add_event(Event({
            trigger = 'before',delay = 0.5,
            func = function()
                --Add the far left text and context first:
                local left_text = {}
                if config.name == 'blind1' then
                    local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
                    local obj = G.GAME.blind.config.blind
                    local blind_sprite = AnimatedSprite(0, 0, 1.2, 1.2, G.ANIMATION_ATLAS[obj.atlas] or G.ANIMATION_ATLAS['blind_chips'], copy_table(G.GAME.blind.pos))
                    blind_sprite:define_draw_steps({
                        {shader = 'dissolve', shadow_height = 0.05},
                        {shader = 'dissolve'}
                    })
                    table.insert(left_text, {n=G.UIT.O, config={w=1.2,h=1.2 , object = blind_sprite, hover = true, can_collide = false}})
                    
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

                    table.insert(left_text,                  
                    config.saved and 
                    {n=G.UIT.C, config={padding = 0.05, align = 'cm'}, nodes={
                        {n=G.UIT.R, config={align = 'cm'}, nodes={
                            {n=G.UIT.O, config={object = DynaText({string = {' '..(type(G.GAME.saved_text) == 'string' and (G.localization.misc.dictionary[G.GAME.saved_text] and localize(G.GAME.saved_text) or G.GAME.saved_text) or localize('ph_mr_bones'))..' '}, colours = {G.C.FILTER}, shadow = true, pop_in = 0, scale = 0.5*scale, silent = true})}}
                        }}
                    }}
                    or {n=G.UIT.C, config={padding = 0.05, align = 'cm'}, nodes={
                        {n=G.UIT.R, config={align = 'cm'}, nodes={
                            {n=G.UIT.O, config={object = DynaText({string = {' '..localize('ph_score_at_least')..' '}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}}
                        }},
                        {n=G.UIT.R, config={align = 'cm', minh = 0.8}, nodes={
                            {n=G.UIT.O, config={w=0.5,h=0.5 , object = stake_sprite, hover = true, can_collide = false}},
                            {n=G.UIT.T, config={text = G.GAME.blind.chip_text, scale = scale_number(G.GAME.blind.chips, scale, 100000), colour = G.C.RED, shadow = true}}
                        }}
                    }}) 
                elseif string.find(config.name, 'tag') then
                    local blind_sprite = Sprite(0, 0, 0.7,0.7, G.ASSET_ATLAS['tags'], copy_table(config.pos))
                    blind_sprite:define_draw_steps({
                        {shader = 'dissolve', shadow_height = 0.05},
                        {shader = 'dissolve'}
                    })
                    blind_sprite:juice_up()
                    table.insert(left_text, {n=G.UIT.O, config={w=0.7,h=0.7 , object = blind_sprite, hover = true, can_collide = false}})
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {config.condition}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})                   
                elseif config.name == 'hands' then
                    table.insert(left_text, {n=G.UIT.T, config={text = config.disp or config.dollars, scale = 0.8*scale, colour = G.C.BLUE, shadow = true, juice = true}})
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {" "..localize{type = 'variable', key = 'remaining_hand_money', vars = {G.GAME.modifiers.money_per_hand or 1}}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
                elseif config.name == 'discards' then
                    table.insert(left_text, {n=G.UIT.T, config={text = config.disp or config.dollars, scale = 0.8*scale, colour = G.C.RED, shadow = true, juice = true}})
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {" "..localize{type = 'variable', key = 'remaining_discard_money', vars = {G.GAME.modifiers.money_per_discard or 0}}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
                elseif config.name == 'custom' then
                    if config.number then table.insert(left_text, {n=G.UIT.T, config={text = config.number, scale = 0.8*scale, colour = config.number_colour or G.C.FILTER, shadow = true, juice = true}}) end
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {" "..config.text}, colours = {config.text_colour or G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
                elseif string.find(config.name, 'joker') then
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = localize{type = 'name_text', set = config.card.config.center.set, key = config.card.config.center.key}, colours = {G.C.FILTER}, shadow = true, pop_in = 0, scale = 0.6*scale, silent = true})}})
                elseif config.name == 'interest' then
                    table.insert(left_text, {n=G.UIT.T, config={text = num_dollars, scale = 0.8*scale, colour = G.C.MONEY, shadow = true, juice = true}})
                    table.insert(left_text,{n=G.UIT.O, config={object = DynaText({string = {" "..localize{type = 'variable', key = 'interest', vars = {G.GAME.interest_amount, 5, G.GAME.interest_amount*G.GAME.interest_cap/5}}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
                end
                local full_row = {n=G.UIT.R, config={align = "cm", minw = 5}, nodes={
                    {n=G.UIT.C, config={padding = 0.05, minw = width*0.55, minh = 0.61, align = "cl"}, nodes=left_text},
                    {n=G.UIT.C, config={padding = 0.05,minw = width*0.45, align = "cr"}, nodes={{n=G.UIT.C, config={align = "cm", id = 'dollar_'..config.name},nodes={}}}}
                }}
        
                if config.name == 'blind1' then
                    G.GAME.blind:juice_up()
                end
                G.round_eval:add_child(full_row,G.round_eval:get_UIE_by_ID(config.bonus and 'bonus_round_eval' or 'base_round_eval'))
                play_sound('cancel', config.pitch or 1)
                play_sound('highlight1',( 1.5*config.pitch) or 1, 0.2)
                if config.card then config.card:juice_up(0.7, 0.46) end
                return true
            end
        }))
        local dollar_row = 0
        num_dollars = to_number(num_dollars); if math.abs(to_number(num_dollars)) > 60 then
            if num_dollars < 0 then --if negative
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',delay = 0.38,
                    func = function()
                        G.round_eval:add_child(
                            {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..config.name}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('$')..format_ui_value(num_dollars)}, colours = {G.C.RED}, shadow = true, pop_in = 0, scale = 0.65, float = true})}}
                            }},
                            G.round_eval:get_UIE_by_ID('dollar_'..config.name))
                        play_sound('coin3', 0.9+0.2*math.random(), 0.7)
                        play_sound('coin6', 1.3, 0.8)
                        return true
                    end
                }))
            else --if positive
            G.E_MANAGER:add_event(Event({
                trigger = 'before',delay = 0.38,
                func = function()
                    G.round_eval:add_child(
                            {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..config.name}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('$')..format_ui_value(num_dollars)}, colours = {G.C.MONEY}, shadow = true, pop_in = 0, scale = 0.65, float = true})}}
                            }},
                            G.round_eval:get_UIE_by_ID('dollar_'..config.name))

                    play_sound('coin3', 0.9+0.2*math.random(), 0.7)
                    play_sound('coin6', 1.3, 0.8)
                    return true
                end
            }))
        --asdf
        end        else
            local dollars_to_loop
            if num_dollars < 0 then dollars_to_loop = (num_dollars*-1)+1 else dollars_to_loop = num_dollars end
            for i = 1, dollars_to_loop do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',delay = 0.18 - ((num_dollars > 20 and 0.13) or (num_dollars > 9 and 0.1) or 0),
                    func = function()
                        if i%30 == 1 then 
                            G.round_eval:add_child(
                                {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..config.name}, nodes={}},
                                G.round_eval:get_UIE_by_ID('dollar_'..config.name))
                                dollar_row = dollar_row+1
                        end

                        local r
                        if i == 1 and num_dollars < 0 then
                            r = {n=G.UIT.T, config={text = '-', colour = G.C.RED, scale = ((num_dollars < -20 and 0.28) or (num_dollars < -9 and 0.43) or 0.58), shadow = true, hover = true, can_collide = false, juice = true}}
                            play_sound('coin3', 0.9+0.2*math.random(), 0.7 - (num_dollars < -20 and 0.2 or 0))
                        else
                            if num_dollars < 0 then r = {n=G.UIT.T, config={text = localize('$'), colour = G.C.RED, scale = ((num_dollars > 20 and 0.28) or (num_dollars > 9 and 0.43) or 0.58), shadow = true, hover = true, can_collide = false, juice = true}}
                            else r = {n=G.UIT.T, config={text = localize('$'), colour = G.C.MONEY, scale = ((num_dollars > 20 and 0.28) or (num_dollars > 9 and 0.43) or 0.58), shadow = true, hover = true, can_collide = false, juice = true}} end
                        end
                        play_sound('coin3', 0.9+0.2*math.random(), 0.7 - (num_dollars > 20 and 0.2 or 0))
                        
                        if config.name == 'blind1' then 
                            G.GAME.current_round.dollars_to_be_earned = G.GAME.current_round.dollars_to_be_earned:sub(2)
                        end

                        G.round_eval:add_child(r,G.round_eval:get_UIE_by_ID('dollar_row_'..(dollar_row)..'_'..config.name))
                        G.VIBRATION = G.VIBRATION + 0.4
                        return true
                    end
                }))
            end
        end
    else
        delay(0.4)
        G.E_MANAGER:add_event(Event({
            trigger = 'before',delay = 0.5,
            func = function()
                UIBox{
                    definition = {n=G.UIT.ROOT, config={align = 'cm', colour = G.C.CLEAR}, nodes={
                        {n=G.UIT.R, config={id = 'cash_out_button', align = "cm", padding = 0.1, minw = 7, r = 0.15, colour = G.C.ORANGE, shadow = true, hover = true, one_press = true, button = 'cash_out', focus_args = {snap_to = true}}, nodes={
                            {n=G.UIT.T, config={text = localize('b_cash_out')..": ", scale = 1, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                            {n=G.UIT.T, config={text = localize('$')..format_ui_value(config.dollars), scale = 1.2*scale, colour = G.C.WHITE, shadow = true, juice = true}}
                    }},}},
                    config = {
                      align = 'tmi',
                      offset ={x=0,y=0.4},
                      major = G.round_eval}
                }

                --local left_text = {n=G.UIT.R, config={id = 'cash_out_button', align = "cm", padding = 0.1, minw = 2, r = 0.15, colour = G.C.ORANGE, shadow = true, hover = true, one_press = true, button = 'cash_out', focus_args = {snap_to = true}}, nodes={
                --    {n=G.UIT.T, config={text = localize('b_cash_out')..": ", scale = 1, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                --    {n=G.UIT.T, config={text = localize('$')..format_ui_value(config.dollars), scale = 1.3*scale, colour = G.C.WHITE, shadow = true, juice = true}}
                --}}
                --G.round_eval:add_child(left_text,G.round_eval:get_UIE_by_ID('eval_bottom'))

                G.GAME.current_round.dollars = config.dollars
                
                play_sound('coin6', config.pitch or 1)
                G.VIBRATION = G.VIBRATION + 1
                return true
            end
        }))
    end
end

-- Not used yet :sob:

G.FUNCS = G.FUNCS or {}

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
    
    --[[if #G.shop_freeze.cards >= (G.GAME.starting_params.freeze_max or 1) then
        attention_text({ text = localize('k_no_room_ex'), scale = 0.6 })
        return false
    end]]

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
end

-- Worst time of my life

local game_start_run_ref = Game.start_run

function Game:start_run(args)
    game_start_run_ref(self, args)

    SMODS.set_scoring_calculation("GG_powerCalc")
end
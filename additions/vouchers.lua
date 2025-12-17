local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

-- Lucky Day, Potent Gamble
SMODS.Voucher {
    key = "GG_luckyday",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 1
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "v_GG_luckyday"
        }
    end,

    cost = 10,

    redeem = function(self, card)
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v*1.5
        end
    end
}

SMODS.Voucher {
    key = "GG_potentgamble",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 1
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "v_GG_potentgamble"
        }
    end,

    cost = 10,

    requires = {
        "v_GG_luckyday"
    },

    redeem = function(self, card)
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v*(2/1.5)
        end
    end
}

-- Runic Script, Arcane Pact
SMODS.Voucher {
    key = "GG_runicscript",
    atlas = "atlasholders",
    pos = {
        x = 0,
        y = 1
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "v_GG_runicscript",
            vars = {
                colours = {
                    HEX("d745c3")
                }
            }
        }
    end,

    cost = 10,

    redeem = function(self, card)
        G.GAME.gg_sigils_rate = 3
    end
}

SMODS.Voucher {
    key = "GG_arcanepact",
    atlas = "atlasholders",
    pos = {
        x = 1,
        y = 1
    },

    config = {
        sigil_mul = 2
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "v_GG_arcanepact",
            vars = {
                colours = {
                    HEX("d745c3")
                },

                card.ability.sigil_mul
            }
        }
    end,

    cost = 10,

    requires = {
        "v_GG_runicenscryption"
    },

    redeem = function(self, card)
        G.GAME.gg_sigils_rate = G.GAME.gg_sigils_rate * card.ability.sigil_mul
    end
}

-- Overrides
SMODS.Voucher:take_ownership(
    "v_overstock_norm",
    {
        redeem = function(self, card)
            if not G.GAME.shop then return end

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
    }
) 

SMODS.Voucher:take_ownership(
    "v_overstock_plus",
    {
        loc_txt = {
            name="Overstock Plus",
            text={
                "{C:attention}+1{} card slot",
                "available in shop",
            }
        },

        redeem = function(self, card)
            if not G.GAME.shop then return end

            local mod = 2

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
    }
)
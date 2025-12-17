local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

SMODS.Stake {
    key = "GG_platinum",
    applied_stakes = {"gold"},

    atlas = "atlasstakes",
    pos = {
        x = 0,
        y = 0
    },

    sticker_atlas = "atlasstickers",
    sticker_pos = {
        x = 0,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "stake_GG_platinum"
        }
    end,

    colour = HEX("b2f1f7"),
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },

    modifiers = function()
        G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size - 1
    end,

    shiny = true
}

SMODS.Stake {
    key = "GG_diamond",
    applied_stakes = {"GG_platinum"},

    atlas = "atlasstakes",
    pos = {
        x = 1,
        y = 0
    },

    sticker_atlas = "atlasstickers",
    sticker_pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "stake_GG_diamond"
        }
    end,

    colour = HEX("75d6df"),
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },

    modifiers = function()
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
    end
}
local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

SMODS.Sticker {
    key = "GG_rotten",
    
    atlas = "atlasstickers",
    pos = {
        x = 0,
        y = 2
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "GG_rotten"
        }
    end,

    badge_colour = HEX("11641c"),
    rate = 0.2,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if pseudorandom("GG_rotten") < 1 / 4 then
                local position = nil
                local cardarea = nil

                for i, v in ipairs(G.jokers.cards) do
                    if v == card then
                        position = i
                        cardarea = G.jokers.cards
                    end
                end

                if not cardarea then
                    for i, v in ipairs(G.hand.cards) do
                        if v == card then
                            position = i
                            cardarea = G.hand.cards
                        end
                    end
                end

                local adjacents = {}

                if cardarea[position - 1] then
                    adjacents[#adjacents + 1] = cardarea[position - 1]
                end

                if cardarea[position + 1] then
                    adjacents[#adjacents + 1] = cardarea[position + 1]
                end

                local selected = CalcLib.get_random_items(adjacents, 1, "GG_rotten")

                SMODS.destroy_cards(selected)

                return {
                    message = "Rotted",
                    colour = HEX("11641c"),
                    card = selected
                }
            end
        end
    end
}
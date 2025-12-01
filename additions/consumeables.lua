-- Omnipotence
SMODS.Consumable {
    key = "GG_omnipotence",
    set = "Spectral",

    atlas = "atlasholders",
    pos = {
        x = 2,
        y = 2
    },

    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {
            key = "s_GG_omnipotence" 
        }
    end,

    can_use = function(self, card)
        if G.GAME.round_resets.discards > 0 then
            return true
        end

        return false
    end,

    use = function(self, card, area, copier)
        ease_ante(-1)
        ease_discard(-1)

        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
    end
}

-- Phantom
SMODS.Consumable {
    key = "GG_phantom",
    set = "Spectral",

    atlas = "atlasholders",
    pos = {
        x = 2,
        y = 2
    },

    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {
            key = "s_GG_phantom"
        }
    end,

    can_use = function(self, card)
        local stickers = 0
        local dollars = G.GAME.dollars:to_number()

        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.eternal then
                stickers = stickers + 1
            end

            if G.jokers.cards[i].ability.perishable then
                stickers = stickers + 1
            end

            if G.jokers.cards[i].ability.rental then
                stickers = stickers + 1
            end
        end

        return stickers > 0 and dollars >= stickers * 5
    end,

    use = function(self, card, area, copier)
        local stickers = 0

        for i = 1, #G.jokers.cards do
            G.jokers.cards:flip()

            if G.jokers.cards[i].ability.eternal then
                G.jokers.cards[i].ability.eternal = false
                stickers = stickers + 1

                G.jokers.cards[i]:juice_up(0.3, 0.4)
            end

            if G.jokers.cards[i].ability.perishable then
                G.jokers.cards[i].ability.perishable = false
                stickers = stickers + 1

                G.jokers.cards[i]:juice_up(0.3, 0.4)
            end

            if G.jokers.cards[i].ability.rental then
                G.jokers.cards[i].ability.rental = false
                stickers = stickers + 1

                G.jokers.cards[i]:juice_up(0.3, 0.4)
            end

            delay(0.1)

            G.jokers.cards:flip()
        end

        ease_dollars(stickers * -5)
    end
}
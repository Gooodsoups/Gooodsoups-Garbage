--[[
    ----------Ideas----------

    Agustosbocegi (Legendary): Pick a random card from deck, if you trigger a card of that value, give x1.25 power and change rank, very
    fucking broken with deckfixing lmao

    Rock Bottom (Rare): Disable the negative effects of jokers, consumables etc, like ecto not removing ur hand size or other stuff :pray:
    also stops glass from breaking which is pretty coooooooooool

    Pea Shooter (Uncommon): Upon entering a blind, the boss loses 10% of it's requirement

    Deck idea: Non tainted jokers are debuffed, start with a tainted negative eternal bag consumable (gives 3 random jokers maybe)
    sell 4 items and gain a tainted joker or consumable depending on which type you sold more with a rarity depending on what rarity
    items you sold (holy wtf)

    some money deck: convert current money into smth idk, maybe x(money/100) idkkkkkk

    sei seal: does something idk

    make soul and rares nonexistant but every uncommon and common gives 1.5X of everything it normally does
    
    ----------Code dictionary (idk when im using this xd)----------

    ::Removes the shine shader on created seals::

    draw = function(self, card)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
    end

    local text = localize("k_balanced")
    play_sound("gong", 0.94, 0.3)
    play_sound("gong", 0.94 * 1.5, 0.2)
    play_sound("tarot1", 1.5)
    ease_colour(G.C.UI_CHIPS, { 0.8, 0.45, 0.85, 1 })
    ease_colour(G.C.UI_MULT, { 0.8, 0.45, 0.85, 1 })
    attention_text({
        scale = 1.4,
        text = text,
        hold = 2,
        align = "cm",
        offset = { x = 0, y = -2.7 },
        major = G.play,
    }) 
]]

--[[

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

]]

--[[
    function Game:update_shop(dt)
        if not G.STATE_COMPLETE then
            stop_use()
            ease_background_colour_blind(G.STATES.SHOP)
            local shop_exists = not not G.shop
            G.shop = G.shop or UIBox{
                definition = G.UIDEF.shop(),
                config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
            }
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.shop.alignment.offset.y = -5.3
                        G.shop.alignment.offset.x = 0
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            blockable = false,
                            func = function()
                                if math.abs(G.shop.T.y - G.shop.VT.y) < 3 then
                                    G.ROOM.jiggle = G.ROOM.jiggle + 3
                                    play_sound('cardFan2')
                                    for i = 1, #G.GAME.tags do
                                        G.GAME.tags[i]:apply_to_run({type = 'shop_start'})
                                    end
                                    local nosave_shop = nil
                                    if not shop_exists then
                                    
                                        if G.load_shop_jokers then 
                                            nosave_shop = true
                                            G.shop_jokers:load(G.load_shop_jokers)
                                            for k, v in ipairs(G.shop_jokers.cards) do
                                                create_shop_card_ui(v)
                                                if v.ability.consumeable then v:start_materialize() end
                                                for _kk, vvv in ipairs(G.GAME.tags) do
                                                    if vvv:apply_to_run({type = 'store_joker_modify', card = v}) then break end
                                                end
                                            end
                                            G.load_shop_jokers = nil
                                        else
                                            for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
                                                G.shop_jokers:emplace(create_card_for_shop(G.shop_jokers))
                                            end
                                        end

                                        if G.GAME.current_round.frozen_card then
                                            local card = G.GAME.current_round.frozen_card

                                            create_shop_card_ui(card, 'Shop', G.shop_freeze)
                                            G.shop_freeze:emplace(card)
                                            card:start_materialize()
                                        end
                                        
                                        if G.load_shop_vouchers then 
                                            nosave_shop = true
                                            G.shop_freeze:load(G.load_shop_vouchers)
                                            for k, v in ipairs(G.shop_freeze.cards) do
                                                create_shop_card_ui(v)
                                                v:start_materialize()
                                            end
                                            G.load_shop_vouchers = nil
                                        else
                                            if G.GAME.current_round.voucher and G.P_CENTERS[G.GAME.current_round.voucher] then
                                                local card = Card(G.shop_freeze.T.x + G.shop_freeze.T.w/2,
                                                G.shop_freeze.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.voucher],{bypass_discovery_center = true, bypass_discovery_ui = true})
                                                card.shop_voucher = true
                                                create_shop_card_ui(card, 'Voucher', G.shop_freeze)
                                                card:start_materialize()
                                                G.shop_freeze:emplace(card)
                                            end
                                        end
                                        

                                        if G.load_shop_booster then 
                                            nosave_shop = true
                                            G.shop_booster:load(G.load_shop_booster)
                                            for k, v in ipairs(G.shop_booster.cards) do
                                                create_shop_card_ui(v)
                                                v:start_materialize()
                                            end
                                            G.load_shop_booster = nil
                                        else
                                            for i = 1, 2 do
                                                G.GAME.current_round.used_packs = G.GAME.current_round.used_packs or {}
                                                if not G.GAME.current_round.used_packs[i] then
                                                    G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key
                                                end

                                                if G.GAME.current_round.used_packs[i] ~= 'USED' then 
                                                    local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                                                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[i] ], {bypass_discovery_center = true, bypass_discovery_ui = true})
                                                    create_shop_card_ui(card, 'Booster', G.shop_booster)
                                                    card.ability.booster_pos = i
                                                    card:start_materialize()
                                                    G.shop_booster:emplace(card)
                                                end
                                            end

                                            for i = 1, #G.GAME.tags do
                                                G.GAME.tags[i]:apply_to_run({type = 'voucher_add'})
                                            end
                                            for i = 1, #G.GAME.tags do
                                                G.GAME.tags[i]:apply_to_run({type = 'shop_final_pass'})
                                            end
                                        end
                                    end

                                    G.CONTROLLER:snap_to({node = G.shop:get_UIE_by_ID('next_round_button')})
                                    if not nosave_shop then
                                        G.E_MANAGER:add_event(Event({func = function()
                                            G.shop_freeze:save()
                                            
                                            save_run()
                                            return true end
                                        }))
                                    end
                                    return true
                                end
                            end}))
                        return true
                    end
                }))
            G.STATE_COMPLETE = true
        end  
        if self.buttons then self.buttons:remove(); self.buttons = nil end          
    end
]]
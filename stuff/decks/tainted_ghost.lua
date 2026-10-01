SMODS.Back {
  key = "tainted_ghost",
  atlas = 'deck_atlas',
  pos = { x = 6, y = 0 },
  config = { spectral_rate = 2 },
  loc_vars = function(self, info_queue, back)
      return { vars = {  } }
  end,
  apply = function(self, back)
    G.GAME.OTFS.no_spectral_downsides = true
  end,
  calculate = function (self, back, context)
    if context.ending_shop then
      return {
        dollars = math.min(-G.GAME.dollars, 0)
      }
    end
  end
}

-- vanilla functions borrowed from vanillaremade

SMODS.Consumable:take_ownership('ankh',
{
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
      local main_end = {}
      if G.jokers and G.jokers.cards then
        for _, joker in ipairs(G.jokers.cards) do
          if joker.edition and joker.edition.negative then
            localize { type = 'other', key = 'remove_negative', nodes = main_end, vars = {} }
            break
          end
        end
      end
      return { main_end = main_end[1],
               key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_ankh_buff" or "c_ankh" }
    end,
    use = function(self, card, area, copier)
      local deletable_jokers = {}
      if not G.GAME.OTFS.no_spectral_downsides then
        for _, joker in ipairs(G.jokers.cards) do
          if not SMODS.is_eternal(joker, card) then deletable_jokers[#deletable_jokers + 1] = joker end
        end
      end

      local chosen_joker = pseudorandom_element(G.jokers.cards, 'vremade_ankh_choice')
      local _first_dissolve = nil
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.75,
        func = function()
          for _, joker in ipairs(deletable_jokers) do
            if joker ~= chosen_joker then
              joker:start_dissolve(nil, _first_dissolve)
              _first_dissolve = true
            end
          end
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.4,
        func = function()
          local copied_joker = SMODS.copy_card(chosen_joker,
            { strip_edition = chosen_joker.edition and chosen_joker.edition.negative })
          copied_joker:start_materialize()
          return true
        end
      }))
    end,
    can_use = function(self, card)
      return G.jokers and #G.jokers.cards > 0 and #G.jokers.cards < G.jokers.config.card_limit
    end,
})

SMODS.Consumable:take_ownership('ectoplasm',
{
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
    return { vars = { G.GAME.ecto_minus or 1},
                      key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_ectoplasm_buff" or "c_ectoplasm" }
  end,
  use = function(self, card, area, copier)
    local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        local eligible_card = pseudorandom_element(editionless_jokers, 'vremade_ectoplasm')
        eligible_card:set_edition("e_negative")

        if not G.GAME.OTFS.no_spectral_downsides then
          G.GAME.ecto_minus = G.GAME.ecto_minus or 1
          G.hand:change_size(-G.GAME.ecto_minus)
          G.GAME.ecto_minus = G.GAME.ecto_minus + 1
        end

        card:juice_up(0.3, 0.5)
        return true
      end
    }))
  end,
  can_use = function(self, card)
    return next(SMODS.Edition:get_edition_cards(G.jokers, true))
  end,
})

SMODS.Consumable:take_ownership('familiar',
  {
    config = { extra = { destroy = 1, cards = 3 } },
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.destroy, card.ability.extra.cards },
               key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_familiar_buff" or "c_familiar"}
    end,
    use = function(self, card, area, copier)
      local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
      if G.GAME.OTFS.no_spectral_downsides then
        card_to_destroy = G.hand.highlighted
      end
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          play_sound('tarot1')
          card:juice_up(0.3, 0.5)
          return true
        end
      }))
      SMODS.destroy_cards(card_to_destroy)

      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.7,
        func = function()
          local cards = {}
          for i = 1, card.ability.extra.cards do
            local faces = {}
            for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
              local rank = SMODS.Ranks[rank_key]
              if rank.face then table.insert(faces, rank) end
            end
            local _rank = pseudorandom_element(faces, 'vremade_familiar_create').card_key
            local cen_pool = {}
            for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
              if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                cen_pool[#cen_pool + 1] = enhancement_center.key
              end
            end
            local enhancement = SMODS.poll_enhancement { guaranteed = true, options = cen_pool, key = "vremade_spe_card" }
            cards[i] = SMODS.add_card { set = "Base", rank = _rank, enhancement = enhancement, key_append = "vremade_familiar_card" }
          end
          SMODS.calculate_context({ playing_card_added = true, cards = cards })
          return true
        end
      }))
      delay(0.3)
    end,
    can_use = function(self, card)
      if G.GAME.OTFS.no_spectral_downsides then
        return #G.hand.highlighted <= card.ability.extra.destroy
      else
        return G.hand and #G.hand.cards > 1
      end
    end,
  }
)

SMODS.Consumable:take_ownership('grim',
  {
    config = { extra = { destroy = 1, cards = 2 } },
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.destroy, card.ability.extra.cards },
               key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_grim_buff" or "c_grim"}
    end,
    use = function(self, card, area, copier)
      local card_to_destroy = pseudorandom_element(G.hand.cards, 'vremade_grim_random_destroy')
      if G.GAME.OTFS.no_spectral_downsides then
        card_to_destroy = G.hand.highlighted
      end
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          play_sound('tarot1')
          card:juice_up(0.3, 0.5)
          return true
        end
      }))
      SMODS.destroy_cards(card_to_destroy)

      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.7,
        func = function()
          local cards = {}
          for i = 1, card.ability.extra.cards do
            local cen_pool = {}
            for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
              if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                cen_pool[#cen_pool + 1] = enhancement_center.key
              end
            end
            local enhancement = SMODS.poll_enhancement { guaranteed = true, options = cen_pool, key = "vremade_spe_card" }
            cards[i] = SMODS.add_card { set = "Base", rank = 'Ace', enhancement = enhancement, key_append = "vremade_grim_card" }
          end
          SMODS.calculate_context({ playing_card_added = true, cards = cards })
          return true
        end
      }))
      delay(0.3)
    end,
    can_use = function(self, card)
      if G.GAME.OTFS.no_spectral_downsides then
        return #G.hand.highlighted <= card.ability.extra.destroy
      else
        return G.hand and #G.hand.cards > 1
      end
    end,
  }
)

SMODS.Consumable:take_ownership('hex',
  {
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
      return { key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_hex_buff" or "c_hex"}
    end,
    use = function(self, card, area, copier)
      local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          local eligible_card = pseudorandom_element(editionless_jokers, 'vremade_hex')
          eligible_card:set_edition("e_polychrome")

          local _first_dissolve = nil
          for _, joker in ipairs(G.jokers.cards) do
            if joker ~= eligible_card and not SMODS.is_eternal(joker, card) and G.GAME.OTFS.no_spectral_downsides then
              joker:start_dissolve(nil, _first_dissolve)
              _first_dissolve = true
            end
          end

          card:juice_up(0.3, 0.5)
          return true
        end
      }))
    end,
    can_use = function(self, card)
      return next(SMODS.Edition:get_edition_cards(G.jokers, true))
    end,
  }
)

SMODS.Consumable:take_ownership('immolate',
{
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.destroy, card.ability.extra.dollars },
             key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_immolate_buff" or "c_immolate" }
  end,
  use = function(self, card, area, copier)
    local destroyed_cards = {}
    local temp_hand = {}

    if G.GAME.OTFS.no_spectral_downsides then
      destroyed_cards = G.hand.highlighted
    else
      for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
      table.sort(temp_hand,
        function(a, b)
          return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
        end
      )
      pseudoshuffle(temp_hand, 'vremade_immolate')
      for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards + 1] = temp_hand[i] end
    end
    
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('tarot1')
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    SMODS.destroy_cards(destroyed_cards)

    delay(0.5)
    ease_dollars(card.ability.extra.dollars)
    delay(0.3)
  end,
  can_use = function(self, card)
    if G.GAME.OTFS.no_spectral_downsides then
      return #G.hand.highlighted <= card.ability.extra.destroy
    else
      return G.hand and #G.hand.cards > 1
    end
  end,
})

SMODS.Consumable:take_ownership('incantation',
  {
    config = { extra = { destroy = 1, cards = 4 } },
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.destroy, card.ability.extra.cards },
               key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_incantation_buff" or "c_incantation"}
    end,
    use = function(self, card, area, copier)
      local card_to_destroy = pseudorandom_element(G.hand.cards, 'vremade_incantation_random_destroy')
      if G.GAME.OTFS.no_spectral_downsides then
        card_to_destroy = G.hand.highlighted
      end
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          play_sound('tarot1')
          card:juice_up(0.3, 0.5)
          return true
        end
      }))
      SMODS.destroy_cards(card_to_destroy)

      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.7,
        func = function()
            local cards = {}
            for i = 1, card.ability.extra.cards do
              local numbers = {}
              for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
                local rank = SMODS.Ranks[rank_key]
                if rank_key ~= 'Ace' and not rank.face then table.insert(numbers, rank) end
              end
              local _rank = pseudorandom_element(numbers, 'vremade_incantation_create').card_key
              local cen_pool = {}
              for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                  cen_pool[#cen_pool + 1] = enhancement_center.key
                end
              end
              local enhancement = SMODS.poll_enhancement { guaranteed = true, options = cen_pool, key = "vremade_spe_card" }
              cards[i] = SMODS.add_card { set = "Base", rank = _rank, enhancement = enhancement, key_append = "vremade_incantation_card" }
            end
            SMODS.calculate_context({ playing_card_added = true, cards = cards })
            return true
          end
        }))
      delay(0.3)
    end,
    can_use = function(self, card)
      if G.GAME.OTFS.no_spectral_downsides then
        return #G.hand.highlighted <= card.ability.extra.destroy
      else
        return G.hand and #G.hand.cards > 1
      end
    end,
  }
)

SMODS.Consumable:take_ownership('ouija',
  {
    loc_vars = function(self, info_queue, card)
      return { key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_ouija_buff" or "c_ouija"}
    end,
    use = function(self, card, area, copier)
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          play_sound('tarot1')
          card:juice_up(0.3, 0.5)
          return true
        end
      }))
      for i = 1, #G.hand.cards do
        local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.15,
          func = function()
              G.hand.cards[i]:flip()
              play_sound('card1', percent)
              G.hand.cards[i]:juice_up(0.3, 0.3)
              return true
          end
        }))
      end
      local _rank = pseudorandom_element(SMODS.Ranks, 'vremade_ouija')
      for i = 1, #G.hand.cards do
        G.E_MANAGER:add_event(Event({
          func = function()
            local _card = G.hand.cards[i]
            assert(SMODS.change_base(_card, nil, _rank.key))
            return true
          end
        }))
      end
      if not G.GAME.OTFS.no_spectral_downsides then G.hand:change_size(-1) end
      for i = 1, #G.hand.cards do
        local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.15,
          func = function()
            G.hand.cards[i]:flip()
            play_sound('tarot2', percent, 0.6)
            G.hand.cards[i]:juice_up(0.3, 0.3)
            return true
          end
        }))
      end
      delay(0.5)
    end,
    can_use = function(self, card)
      return G.hand and #G.hand.cards > 1
    end,
  }
)

SMODS.Consumable:take_ownership('wraith',
  {
    loc_vars = function(self, info_queue, card)
      return { key = G.GAME.OTFS.no_spectral_downsides and "c_otfs_wraith_buff" or "c_wraith"}
    end,
    use = function(self, card, area, copier)
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          play_sound('timpani')
          SMODS.add_card({ set = 'Joker', rarity = 'Rare', key_append = 'vremade_wra' })
          card:juice_up(0.3, 0.5)
          if G.GAME.dollars ~= 0 and not G.GAME.OTFS.no_spectral_downsides then
            ease_dollars(-G.GAME.dollars, true)
          end
          return true
        end
      }))
      delay(0.6)
    end,
    can_use = function(self, card)
      return #G.jokers.cards < G.jokers.config.card_limit or card.area == G.jokers
    end,
  }
)
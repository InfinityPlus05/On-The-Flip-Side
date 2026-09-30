local function check_most_played_hands()
  -- most played hand code borrowed from paperback
    local hands = {}

    for _, v in ipairs(G.P_CENTER_POOLS.Planet) do
      if v.config and v.config.hand_type then
        local hand = G.GAME.hands[v.config.hand_type]

        if hand and hand.visible then
          hands[#hands + 1] = {
            key = v.config.hand_type,
            hand = hand,
            planet_key = v.key
          }
        end
      end
    end

    table.sort(hands, function(a, b)
      if a.hand.played ~= b.hand.played then
        return a.hand.played > b.hand.played
      end

      return (a.hand.s_mult * a.hand.s_chips) > (b.hand.s_mult * b.hand.s_chips)
    end)
    return hands
end
SMODS.Back {
  key = 'tainted_nebula',
  atlas = 'deck_atlas',
  pos = { x = 5, y = 0 },
  config = { vouchers = {'v_telescope', 'v_observatory'}, consumable_slot = 3 },
  loc_vars = function(self, info_queue, back)
    return { vars = { 
      localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
      localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' },
      localize { type = 'name_text', set = 'Joker', key = 'j_astronomer' },
      self.config.consumable_slot
     } }
  end,
  apply = function(self, back)
    G.E_MANAGER:add_event(Event({
      func = function()
        SMODS.add_card {
          set = 'Joker',
          key = 'j_astronomer',
          edition = 'e_negative',
          key_append = 'tainted_nebula'
        }
        return true
      end
    }))
  end,
  calculate = function (self, back, context)
    if context.final_scoring_step then
      -- most played hand code borrowed from paperback
      local hands = check_most_played_hands()

      if (hands[1].hand.played) > hands[2].hand.played then
        hand_chips = hand_chips * -1
        G.E_MANAGER:add_event(Event({
          func = (function()
            local text = localize('k_otfs_negative_score')
            play_sound('negative', 0.94, 0.3)
            play_sound('negative', 0.94*1.5, 0.2)
            play_sound('tarot1', 1.5)
            ease_colour(G.C.UI_CHIPS, {0.37, 0.37, 0.97, 1})
            ease_colour(G.C.UI_MULT, {0.37, 0.37, 0.97, 1})
            attention_text({
              scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
            })
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              blockable = false,
              blocking = false,
              delay =  4.3,
              func = (function() 
                ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                ease_colour(G.C.UI_MULT, G.C.RED, 2)
                return true
              end)
            }))
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              blockable = false,
              blocking = false,
              no_delete = true,
              delay =  6.3,
              func = (function() 
                G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                return true
              end)
            }))
            return true
          end)
        }))
      end
    end
  end
}
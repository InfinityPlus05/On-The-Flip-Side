SMODS.Back {
  key = 'tainted_magic',
  atlas = 'deck_atlas',
  pos = { x = 4, y = 0 },
  config = { vouchers = { 'v_crystal_ball', 'v_omen_globe', 'v_tarot_merchant' }, b_dollars = 3 },
  loc_vars = function(self, info_queue, back)
    return {
      vars = { 
        localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
        localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' },
        localize { type = 'name_text', key = self.config.vouchers[3], set = 'Voucher' },
        localize { type = 'name_text', key = "c_fool", set = 'Tarot' },
        self.config.b_dollars
      }
    }
  end,
  calculate = function (self, back, context)
    if context.using_consumeable and (context.consumeable.ability.set == "Spectral" or context.consumeable.ability.set == "Tarot") then
      G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - self.config.b_dollars
      return {
        dollars = -1 * self.config.b_dollars,
        func = function() -- This is for timing purposes, it runs after the dollar manipulation
          G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.dollar_buffer = 0
                return true
            end
          }))
        end
      }
    end
  end
}

local createcard_ref = create_card
function create_card(...)
  local card = createcard_ref(...)
  if G.STATE == G.STATES.SHOP and card.config.center.set == "Tarot" and G.GAME.selected_back.effect.center.key == "b_otfs_tainted_magic" then
    for i, v in pairs(G.P_CENTER_POOLS.Consumeables) do
      if v.key == 'c_fool' then
        card:set_ability(v)
        break
      end
    end
  end
  return card
end
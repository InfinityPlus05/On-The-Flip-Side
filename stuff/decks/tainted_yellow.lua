--[[ TODO
SMODS.Back {
  key = 'tainted_yellow',
  atlas = 'deck_atlas',
  pos = { x = 2, y = 0 },
  config = { dollars = 10, xmult = 1.5, dollars_required = 15},
  loc_vars = function(self, info_queue, back)
    return { vars = { self.config.dollars, 
    self.config.selection_limit, self.config.chips  } }
  end,
  apply = function(self, back)
    G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.interest_cap = (1e299)
				return true
			end,
		}))

    G.GAME.modifiers.otfs_negative_interest = true
  end,
  calculate = function (self, back, context)

  end
}

SMODS.DrawStep {
  key = 'deck_shader',
  order = 5,
  func = function(self)
    local selected_back = G.GAME and (G.GAME.viewed_back or G.GAME.selected_back)
    local selected_back_key = selected_back and selected_back.effect and selected_back.effect.center
        and selected_back.effect.center.key

    if self.children.back
        and selected_back_key == 'b_otfs_tainted_yellow'
        and self:should_draw_base_shader() then
      self.children.back:draw_shader('voucher', nil, self.ARGS.send_to_shader)
    end
  end,
  conditions = { vortex = false, facing = 'back' }
}]]
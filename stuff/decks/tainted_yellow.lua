SMODS.Back {
  key = 'tainted_yellow',
  atlas = 'yellow_atlas',
  pos = { y = 0 },
  config = { dollars = 11, xmult = 1.5, dollars_required = 15},
  loc_vars = function(self, info_queue, back)
    return { vars = { self.config.dollars, 
    self.config.xmult, self.config.dollars_required  } }
  end,
  apply = function(self, back)
    G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.interest_cap = (1e300)
				return true
			end,
		}))

    G.GAME.OTFS.negative_interest = true
    G.GAME.banned_keys['v_seed_money'] = true
    G.GAME.banned_keys['v_money_tree'] = true
  end,
  calculate = function (self, back, context)
    if context.final_scoring_step then
      local current_money = math.floor(G.GAME.dollars / self.config.dollars_required)
      return {
        xmult = current_money * self.config.xmult
      }
    end
  end
}


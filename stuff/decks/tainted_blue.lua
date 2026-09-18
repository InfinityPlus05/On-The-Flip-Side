SMODS.Back {
  key = 'tainted_blue',
  atlas = 'deck_atlas',
  pos = { x = 1, y = 0 },
  config = { hands = 2, selection_limit = 1, chips = -5},
  loc_vars = function(self, info_queue, back)
    return { vars = { self.config.hands, 
    self.config.selection_limit, self.config.chips  } }
  end,
  apply = function(self, back)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      func = function()
        SMODS.change_play_limit(self.config.selection_limit)
        return true
      end
    }))
  end,
  calculate = function (self, back, context)
    if context.individual and context.cardarea == G.play and (G.GAME.round_resets.discards ~= G.GAME.current_round.discards_left) then
      return {
        chips = self.config.chips * (G.GAME.round_resets.discards - G.GAME.current_round.discards_left)
      }
    end
  end
}
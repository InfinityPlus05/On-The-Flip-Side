SMODS.Back {
  key = 'tainted_red',
  atlas = 'deck_atlas',
  pos = { x = 0, y = 0 },
  config = { discards = 2, hands = -2, selection_limit = 2},
  loc_vars = function(self, info_queue, back)
    return { vars = { self.config.discards, 
    self.config.selection_limit, self.config.hands } }
  end,
  apply = function(self, back)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      func = function()
        SMODS.change_discard_limit(self.config.selection_limit)
        return true
      end
    }))
    G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + (G.GAME.modifiers.money_per_hand or 1)
    G.GAME.modifiers.money_per_hand = 0
  end
}
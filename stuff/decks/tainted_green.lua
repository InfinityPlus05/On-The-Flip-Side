SMODS.Back {
  key = 'tainted_green',
  atlas = 'deck_atlas',
  pos = { x = 2, y = 0 },
  config = { dollars = -34, dollars_zero_discards = 5, dollars_zero_hands = 20},
  loc_vars = function(self, info_queue, back)
    return { vars = { self.config.dollars * -1, self.config.dollars_zero_discards, self.config.dollars_zero_hands } }
  end,
  apply = function(self, back)
    G.GAME.OTFS.cards_give_money = true
  end,
  calc_dollar_bonus = function(self, back)
    local zero_discards = G.GAME.current_round.discards_left == 0
    local zero_hands = G.GAME.current_round.hands_left == 0
    if zero_discards and zero_hands then
      return self.config.dollars_zero_discards + self.config.dollars_zero_hands, {text = "0 Hands & Discards Remaining"}
    elseif zero_discards then
      return self.config.dollars_zero_discards, {text = "0 Discards Remaining"}
    elseif zero_hands then
      return self.config.dollars_zero_hands, {text = "0 Hands Remaining"}
    end
  end

}
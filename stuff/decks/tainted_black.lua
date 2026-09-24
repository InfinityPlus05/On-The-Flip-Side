SMODS.Back {
  key = 'tainted_black',
  atlas = 'deck_atlas',
  pos = { x = 3, y = 0 },
  config = { b_joker_slot = 3, b_discards = 1, b_hands = 1, b_joker_add = 1, b_last_joker_slot_held = 0},
  loc_vars = function(self, info_queue, back)
    return { vars = { self.config.b_joker_slot, self.config.b_hands, 
    self.config.b_discards, self.config.b_joker_add } }
  end,
  apply = function(self, back)
    G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots - self.config.b_joker_slot
    G.GAME.starting_params.hands = G.GAME.starting_params.hands - self.config.b_hands + G.GAME.starting_params.joker_slots
    G.GAME.starting_params.discards = G.GAME.starting_params.discards - self.config.b_discards + G.GAME.starting_params.joker_slots
    self.config.b_last_joker_slot_held = G.GAME.starting_params.joker_slots
  end,
  calculate = function (self, back, context)
    if context.end_of_round and context.main_eval and context.beat_boss then
       G.E_MANAGER:add_event(Event({
        func = function()
          if G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
          end
          return true
        end,
      }))
    end
    if self.config.b_last_joker_slot_held ~= (G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer)) then
      local delta = ((G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer)) - self.config.b_last_joker_slot_held)

      G.GAME.round_resets.discards = G.GAME.round_resets.discards + delta
      ease_discard(delta)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + delta
      ease_hands_played(delta)

      self.config.b_last_joker_slot_held = (G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
    end
  end
}
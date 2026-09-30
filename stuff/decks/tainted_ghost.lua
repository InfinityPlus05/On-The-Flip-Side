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
SMODS.Back {
  key = 'tainted_abandoned',
  atlas = 'deck_atlas',
  pos = { x = 0, y = 1 },
  config = { },
  loc_vars = function(self, info_queue, back)
    return {
      vars = {
        localize { type = 'name_text', set = 'Joker', key = 'j_pareidolia' },
        localize { type = 'name_text', set = 'Blind', key = 'bl_plant' },
        colours = { HEX("709284") }
      }
    }
  end,
  apply = function(self, back)
    G.GAME.OTFS.planting_my_showdown = true
    G.E_MANAGER:add_event(Event({
      func = function()
        SMODS.add_card {
          set = 'Joker',
          key = 'j_pareidolia',
          edition = 'e_negative',
          key_append = 'tainted_abandoned',
          stickers = {"eternal"},
          force_stickers = true
        }
        return true
      end
    }))
  end,
}
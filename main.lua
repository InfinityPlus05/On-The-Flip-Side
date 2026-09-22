OTFS = {}

function OTFS.load(obj, path)
  for i = 1, #obj do
    assert(SMODS.load_file(path .. "/" .. obj[i] .. ".lua"))()
  end
end

SMODS.Atlas {
	key = 'deck_atlas',
	px = 71,
	py = 95,
	disable_mipmap = true,
	path = 'decks.png'
}

SMODS.Atlas {
	key = 'placeholder',
	px = 71,
	py = 95,
	disable_mipmap = true,
	path = 'placeholder.png'
}

SMODS.Atlas {
  key = 'yellow_atlas',
  px = 71,
  py = 95,
  path = 'tainted_yellow.png',
  frames = 21,
  atlas_table = 'ANIMATION_ATLAS'
}

SMODS.load_file("stuff/decks.lua")()

---@diagnostic disable: duplicate-set-field
local init_game_object_ref = Game.init_game_object
function Game.init_game_object(self)
  local ret = init_game_object_ref(self)

	ret.OTFS = {
		negative_interest = false,
		cards_give_money = false
	}

	return ret
end

SMODS.current_mod.calculate = function(self, context)
	if context.individual and context.cardarea == G.play and
		G.GAME.OTFS.cards_give_money then
		G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 1
		return {
			dollars = 1,
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
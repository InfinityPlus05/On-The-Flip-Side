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

function OTFS.is_plant_showdown()
	local ante = G.GAME.round_resets.ante
	return G.GAME.OTFS.planting_my_showdown and ante >= 2 and ante % G.GAME.win_ante == 0
end

local get_new_blind_ref = SMODS.get_new_blind
---@diagnostic disable: duplicate-set-field
function SMODS.get_new_blind(blind_type)
	if blind_type == 'boss' and OTFS.is_plant_showdown() then
		local boss = 'bl_plant'
		SMODS.add_boss_to_used_table(boss, blind_type)
		return boss
	end
	return get_new_blind_ref(blind_type)
end

---@diagnostic disable: duplicate-set-field
local init_game_object_ref = Game.init_game_object
function Game.init_game_object(self)
  local ret = init_game_object_ref(self)

	ret.OTFS = {
		negative_interest = false,
		cards_give_money = false,
		no_spectral_downsides = false,
		planting_my_showdown = false,
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
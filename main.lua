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

SMODS.load_file("stuff/decks.lua")()
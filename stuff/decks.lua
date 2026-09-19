OTFS.enabled_decks = {
  "tainted_red",
  "tainted_blue",
  "tainted_yellow",
  --"tainted_green",
  --"tainted_black",
  --"tainted_magic",
  --"tainted_nebula",
  --"tainted_ghost",
  -- "tainted_abandoned",
  -- "tainted_checkered",
  -- "tainted_zodiac",
  -- "tainted_painted",
  -- "tainted_anaglyph",
  -- "tainted_plasma",
  -- "tainted_erratic"
}

OTFS.load(OTFS.enabled_decks, "stuff/decks")

-- thanks to ^FoxDeploy
SMODS.DrawStep({
  key = "editiondecks",
  order = 5,
  func = function(self)

    local deckToShaderTable = {
      {
        deckName = "b_otfs_tainted_yellow",
        shader   = "voucher",
      },
    }                  
  
    if self.area and self.area.config and self.area.config.type == "deck" then
      local currentBack = (type(self.params.viewed_back) == "table" and self.params.viewed_back)
          or (self.params.viewed_back and G.GAME.viewed_back or G.GAME.selected_back)
          or Back(G.P_CENTERS["b_otfs_tainted_yellow"]) 
      local deckToShaderMapping = nil

      if currentBack and currentBack.effect.center.key then
        for _, entry in ipairs(deckToShaderTable) do
          if currentBack.effect.center.key == entry.deckName then
            deckToShaderMapping = entry.shader
            self.children.back:draw_shader(
                deckToShaderMapping,
                nil,
                self.ARGS.send_to_shader,
                true
            )
            break
          end
        end
      end
    end
  end
})
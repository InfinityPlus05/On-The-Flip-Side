return {
  descriptions = {
    Back = {
      b_otfs_tainted_red = {
        name = "Bloodstained Deck",
        text = {
          "{C:red}+#1#{} discards every round",
          "{C:red}+#2#{} discard selection limit",
          "{C:blue}#3#{} hands every round",
          "Earn money per remaining {C:red}Discard{}",
          "instead of per remaining {C:blue}hand{}"
        }
      },
      b_otfs_tainted_blue = {
        name = "Ocean Blue Deck",
        text = {
          "{C:blue}+#1#{} hands every round",
          "{C:blue}+#2#{} hand selection limit",
          "Scored cards give {C:blue}#3#{} Chips for",
          "every {C:red}Discard{} used per round"
        }
      },
      b_otfs_tainted_yellow = {
        name = "Gold Deck",
        text = {
          "Start with extra {C:money}$#1#",
          "{X:mult,C:white}X#2#{} Mult for every",
          "{C:money}$#3#{} held during hand",
          "Earned {C:attention}Interest{} is",
          "{C:red}subtracted{} from money",
          "Unlimited {C:attention}Interest cap"
        }
      },
      b_otfs_tainted_green = {
        name = "Mint Green Deck",
        text = {
          "Start with extra {C:red}-$#1#",
          "Scored cards earn {C:money}$1{}",
          "Completing a Blind with",
          "{C:red}0{} Discards left gives {C:money}$#2#{}",
          "Completing a Blind with",
          "{C:blue}0{} Hands left gives {C:money}$#3#{}"
        }
      },
      b_otfs_tainted_black = {
        name = "Blacklight Deck",
        text = {
          "{C:attention}-#1#{} Joker slots",
          "{C:blue}-#2#{} hand every round",
          "{C:red}-#3#{} discard every round",
          "Gain {C:blue}+#2#{} hand and {C:red}+#3#{} discard",
          "for each empty Joker{} slot",
          "Gain {C:attention}+#4#{} Joker slot when",
          "defeating a {C:attention}Boss Blind"
        },
      },
      b_otfs_tainted_magic = {
        name = "Psychic Deck",
        text = {
          "Start run with",
          "{C:tarot,T:v_crystal_ball}#1#{}, {C:spectral,T:v_omen_globe}#2#{},",
          "and {C:tarot,T:v_tarot_merchant}#3#",
          "All {C:tarot}Tarot{} cards in shop",
          "are {C:tarot,T:c_fool}#4#",
          "{C:tarot}#4#{} can copy", 
          "{C:spectral}Spectral{} cards",
          "{C:tarot}Tarot{} and {C:spectral}Spectral{} cards",
          "cost {C:money}$3{} to use"
        },
      },
      b_otfs_tainted_nebula = {
        name = "Galaxy Deck",
        text = {
          "Start run with",
          "{C:planet,T:v_telescope}#1#{}, {C:planet,T:v_observatory}#2#{},",
          "and a {C:dark_edition,T:e_negative}Negative",
          "{C:attention,T:j_astronomer}#3#",
          "{C:attention}+#4#{} Consumable Slots",
          "Playing most played hand",
          "{C:red}subtracts{} score"
        },
      },
      b_otfs_tainted_ghost = {
        name = "Vengeful Spirit Deck",
        text = {
          "{C:spectral}Spectral{} cards may",
          "appear in the shop",
          "{C:spectral}Spectral{} cards no longer",
          "have negative effects",
          "{C:attention}Lose all money{} at",
          "end of {C:attention}shop"
        },
      },
      b_otfs_tainted_abandoned = {
        name = "Ruined Deck",
        text = {
          "Start with a {C:dark_edition,T:e_negative}Negative",
          "{C:attention}Eternal {C:attention,T:j_pareidolia}#1#",
          "All {C:attention}Showdown Blinds{} are",
          "replaced by {V:1,T:bl_plant,T_set:Blind}#2#"
        },
      },
    },
    Spectral = {
      c_otfs_ankh_buff ={
        name = "Ankh",
        text={
          "Create a copy of a",
          "random {C:attention}Joker{}"
        },
      },
      c_otfs_ectoplasm_buff ={
        name = "Ectoplasm",
        text={
          "Add {C:dark_edition}Negative{} to",
          "a random {C:attention}Joker"
        },
      },
      c_otfs_familiar_buff ={
        name = "Familiar",
        text={
          "Destroy up to {C:attention}#1#{} selected",
          "card in your hand, add",
          "{C:attention}#2#{} random {C:attention}Enhanced face",
          "{C:attention}cards{} to your hand",
        },
      },
      c_otfs_grim_buff ={
        name = "Grim",
        text={
          "Destroy up to {C:attention}#1#{} selected",
          "card in your hand, add",
          "{C:attention}#1#{} random {C:attention}Enhanced",
          "{C:attention}Aces{} to your hand",
        },
      },
      c_otfs_hex_buff={
        name = "Hex",
        text={
          "Add {C:dark_edition}Polychrome{} to a",
          "random {C:attention}Joker{}",
        },
      },
      c_otfs_immolate_buff ={
        name = "Immolate",
        text={
          "Destroys up to {C:attention}#1#{}",
          "selected cards in hand,",
          "gain {C:money}$#2#",
        },
      },
      c_otfs_incantation_buff={
        name = "Incantation",
        text={
          "Destroy up to {C:attention}#1#{} selected",
          "card in your hand, add",
          "random {C:attention}Enhanced numbered",
          "{C:attention}cards{} to your hand",
        },
      },
      c_otfs_ouija_buff={
        name = "Ouija",
        text={
          "Converts all cards",
          "in hand to a single",
          "random {C:attention}rank",
        },
      },
      c_otfs_wraith_buff={
        name = "Wraith",
        text={
          "Creates a random",
          "{C:red}Rare{C:attention} Joker{}",
        },
      },
    },
  },
  misc = {
    dictionary = {
      k_otfs_negative_score = "Subtracted",
      k_otfs_will_subtract = "This hand will subtract score"
    }
  }
}

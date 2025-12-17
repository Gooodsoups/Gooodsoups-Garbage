return {
    descriptions = {
        Back = {
            
        },
        Blind={
            
        },
        Edition = {
            e_GG_reflective = {
                name = "Reflective",
                text = {
                    "Copy the scoring effect of",
                    "the edition to the",
                    "left of this card"
                }
            },

            e_GG_bronze = {
                name = "Bronze",
                text = {
                    "{X:chips,C:white}X#1#{} Chips when played",
                    "but not scored"
                }
            },

            e_GG_taintedjoker = {
                name = "Tainted",
                text = {
                    "Retrigger all cards {C:attention}1{} time",
                    "{X:mult,C:white}X#1#{} Mult"
                }
            },

            e_GG_taintedcard = {
                name = "Tainted",
                text = {
                    "Retrigger this card {C:attention}1{} time",
                    "{X:mult,C:white}X#1#{} Mult"
                }
            },

            e_GG_rusty = {
                name = "Rusty",
                text = {
                    "Give {X:mult,C:white}X#1#{} Mult",
                    "lose {X:mult,C:white}X#2#{} Mult at the end of round",
                    "but give {C:money}$#3#{}"
                }
            }
        },
        Enhanced = {
            m_GG_amplifier = {
                name="Amplifier Card",
                text={
                    "{V:1}+#1#{} Power"
                },
            }
        },
        Joker = {
            j_GG_impulsejoker = {
                name = "Impulsinis Džokeris",
                text = {
                    "{V:1}+#1#{} Galios"
                }
            },

            j_GG_alphabet = {
                name = "Abėcėlė",
                text = {
                    "{C:mult}+#2#{} Mult kiekvienam {C:attention}unikaliam simboliui{}",
                    "dešininė {C:attention}Džokerių{} vardė",
                    "{C:inactive}(Šiuo metu {}{C:mult}+#1#{} {C:inactive}Mult){}"
                }
            },

            j_GG_hotstreak = {
                name = "Sėkminga serija",
                text = {
                    "Gauk {X:mult,C:white}X#4#{} Mult už kiekvieną {C:attention}3{}",
                    "iš eilės sužaistą ranką",
                    "{C:inactive}(#1#: #2#/3, {}{X:mult,C:white}X#3#{}{C:inactive}){}"
                }
            },

            j_GG_collector = {
                name = "Kolekcionierius",
                text = {
                    "{C:mult}+#1#{} Mult už kiekvieną {C:attention}unikalų{} reitingą",
                    "įskaitytas žaidžiant"
                }
            },

            j_GG_windvane = {
                name = "Vėjo Rodyklė",
                text = {
                    "Pasirinkite du {C:attention}atsitiktinius{} kostiumus",
                    "vieną kostiumą padidina Mult iš {C:mult}+#4#{}",
                    "o kitas sumažina Mult iš {C:mult}-#5#{}",
                    "{C:inactive}({}{C:mult}+1{}{C:inactive}: #1#, {}{C:mult}-2{}{C:inactive}: #2#){}",
                    "{C:inactive}(Šiuo metu {}{C:mult}+#3#{} {C:inactive}Mult){}"
                }
            },

            j_GG_laggypc = {
                name = "Laggy PC",
                text = {
                    "{C:green}#1# in 3{} chance each card {C:attention}held in hand{}",
                    "to retrigger their abilities {C:attention}#2#{} time"
                }
            },

            j_GG_paperclip = {
                name = "Paperclip",
                text = {
                    "Gain {C:mult}+#2#{} Mult each time",
                    "the first scoring card is triggered",
                    "{C:inactive}(Currently {}{C:mult}+#1#{} {C:inactive}Mult){}"
                }
            },

            j_GG_brokenmirror = {
                name = "Broken Mirror",
                text = {
                    "Retrigger the {C:attention}lowest valued",
                    "cards{} scored {C:attention}#1#{} time"
                }
            },

            j_GG_mathrandom = {
                name = "Math.Random()",
                text = {
                    "{C:inactive,E:1}xmult = math.random() <= 0.5 and X2 or X0.75{}"
                }
            },

            j_GG_explosive = {
                name = "Explosive",
                text = {
                    "On the first hand played this round",
                    "{X:mult,C:white}X#1#{} Mult and debuff this joker",
                    "undebuffs at the end of round"
                }
            },

            j_GG_cantaloupe = {
                name = "Cantaloupe",
                text = {
                    "{V:1}+#1#{} Power",
                    "{V:1}-#2#{} Power every reroll"
                }
            },

            j_GG_seigneur = {
                name = "Seigneur",
                text = {
                    "Give {X:mult,C:white}X#2#{} Mult, and destroy itself",
                    "in {C:attention}#1#{} rounds, when destroyed, give",
                    "{C:money}$#3#{}"
                }
            },

            j_GG_uno = {
                name = "Uno!!",
                text = {
                    "Gain {C:chips}+#2#{} Chips when your {C:attention}played{} card",
                    "has the same suit or rank as the",
                    "{C:attention}previous{} card, Chips {C:attention}reset{} upon playing",
                    "a card that does not have a common suit or rank",
                    "{C:inactive}(Currently {}{C:chips}+#1#{}{C:inactive} Chips, previous card: #3#){}"
                }
            },

            j_GG_percentile = {
                name = "Percentile",
                text = {
                    "Give up to {X:mult,C:white}X2{} Mult the {C:attention}closer{}",
                    "both Chips and Mult values are"
                }
            },

            j_GG_tapedegg = {
                name = "Taped Egg",
                text = {
                    "Upon playing a {C:attention}flush{}, give Mult {C:attention}equivalent{}",
                    "to the total value of cards played",
                    "{C:attention}breaks{} after the {C:attention}flush{} is played"
                }
            },

            j_GG_crackedegg = {
                name = "Cracked Egg",
                text = {
                    "Upon playing a single {C:attention}ace{} card",
                    "{C:attention}repair{} this joker, reactivating",
                    "its effects"
                }
            },

            j_GG_777 = {
                name = "777",
                text = {
                    "If the played hand is a {C:attention}Three Of A Kind{}", 
                    "and the first card is a {C:attention}7{}",
                    "destroy that card and gain {C:money}$#1#{}"
                }
            },

            j_GG_investor = {
                name = "Investor",
                text = {
                    "Earn {C:gold}$1{} for every {C:gold}$10{} you have",
                    "at the end of round, capped at {C:attention}double{} the",
                    "ante number"
                }
            },

            j_GG_cursedcoin = {
                name = "Cursed Coin",
                text = {
                    "Earn {C:money}$#1#{}",
                    "at a cost of {X:mult,C:white}X#2#{} Mult"
                }
            },

            j_GG_sinewave = {
                name = "Sine Wave",
                text = {
                    "Give {X:mult,C:white}X#1#{} Mult",
                    "Mult is dependent on hand size",
                    "based on a sine function",
                    "{C:inactive,E:1}(y = sin(3x) + 2){}"
                }
            },

            j_GG_coffin = {
                name = "Coffin",
                text = {
                    "Prevents Death {C:attention}#1#{} #2#",
                    "sets money to {C:money}$0{} upon reviving",
                    "{S:1.1,C:red,E:2}self destructs afterwards{}"
                }
            },

            j_GG_engineerscap = {
                name = "Engineer's Cap",
                text = {
                    "All played {C:attention}numbered{} cards",
                    "have a {C:green}#1# in 4{} chance to",
                    "become {C:attention}Steel{} cards",
                    "when scored"
                }
            },

            j_GG_citadel = {
                name = "Citadel",
                text = {
                    "Give {X:mult,C:white}X#1#{} Mult",
                    "gain {X:mult,C:white}X#2#{} Mult for every card scored"
                }
            },

            j_GG_blackjack = {
                name = "Black Jack",
                text = {
                    "Counts the values of {C:attention}played{} cards",
                    "If the total is less than {C:attention}21{}, gain",
                    "that amount of Mult. If it is at {C:attention}21{}",
                    "give {X:mult,C:white}X#1#{} Mult, otherwise give {X:mult,C:white}X#2#{} Mult"
                }
            },

            j_GG_powercell = {
                name = "Power Cell",
                text = {
                    "Gain {V:1}+#2#{} Power for each discard",
                    "up to {V:1}#3#{} Power, release the Power",
                    "upon playing a {C:attention}5{} card hand",
                    "{C:inactive}({}{V:1}+#1#{} {C:inactive}Power){}"
                }
            },

            j_GG_jonkler = {
                name = "Jonkler",
                text = {
                    "Swaps {C:chips}Chips{} and {C:mult}Mult{}"
                }
            },

            j_GG_little = {
                name = "Little",
                text = {
                    "Gain {X:chips,C:white}X#2#{} Chips",
                    "for every card destroyed",
                    "{C:inactive}(Currently {}{X:chips,C:white}X#1#{}{C:inactive} Chips){}"
                }
            },

            j_GG_bucket = {
                name = "Bucket",
                text = {
                    "Give {B:1,C:white}X#1#{} Power",
                    "gain {B:1,C:white}X#2#{} Power at the end of round"
                }
            },

            j_GG_brimstone = {
                name = "Brimstone",
                text = {
                    "Give {C:mult}+1{}-{C:mult}#1#{} Mult {C:attention}10{} times",
                    "give {X:mult,C:white}X#2#{} at the end"
                }
            }
        },
        Other = {
            GGplatinum_sticker = {
                name = "Platinum Sticker",
                text = {
                    "Used this Joker",
                    "to win on {C:attention}Platinum{}",
                    "{C:attention}Stake{} difficulty",
                }
            },

            GGdiamond_sticker = {
                name="Diamond Sticker",
                text = {
                    "Used this Joker",
                    "to win on {C:attention}Diamond{}",
                    "{C:attention}Stake{} difficulty",
                }
            }
        },
        Planet = {
            
        },
        Spectral = {
            co_GG_omnipotence = {
                name = "Omnipotence",
                text = {
                    "Lose {C:red}-1{} discard every round",
                    "go back {C:attention}1{} ante"
                }
            },

            co_GG_phantom = {
                name = "Phantom",
                text = {
                    "Remove all {C:attention}stickers{} from each Joker",
                    "lose {C:money}$5{} for every {C:attention}sticker{} removed"
                }
            }
        },
        Stake = {
            stake_GGplatinum = {
                name = "Platinum Stake",
                text = {
                    "Start with {C:red}-1{} hand size"
                }
            },

            stake_GGdiamond = {
                name = "Diamond Stake",
                text = {
                    "Required score scales",
                    "faster for each {C:attention}Ante{}",
                }
            }
        },
        Tag = {

        },
        Tarot = {
            
        },
        Voucher = {
            v_GG_luckyday = {
                name = "Lucky Day",
                text = {
                    "Multiply all {C:attention}listed{}",
                    "{C:green,E:1,S:1.1}probabilities{} to 1.5x",
                    "{C:inactive}(ex: {}{C:green}1 in 3{}{C:inactive} -> {}{C:green}1.5 in 3{}{C:inactive}){}",
                }
            },

            v_GG_potentgamble = {
                name = "Potent Gamble",
                text = {
                    "Multiply all {C:attention}listed{}",
                    "{C:green,E:1,S:1.1}probabilities{} to 2x",
                    "{C:inactive}(ex: {}{C:green}1.5 in 3{}{C:inactive} -> {}{C:green}2 in 3{}{C:inactive}){}",
                }
            },

            v_GG_runicscript = {
                name = "Runic Script",
                text = {
                    "{V:1}Sigil{} cards may",
                    "appear in the shop"
                }
            },

            v_GG_arcanepact = {
                name = "Arcane Pact",
                text = {
                    "{V:1}Sigil{} cards appear",
                    "{C:attention}#1#X{} more frequently",
                    "in the shop",
                }
            }
        },
        GG_sigils = {
            co_GG_sigilhope = {
                name = "Sigil of Hope",
                text = {
                    "{C:green}#1# in 2{} chance for {C:attention}3{}",
                    "random cards to gain {C:mult}+5{} Mult",
                    "permanently"
                }
            },

            co_GG_sigilgrace = {
                name = "Sigil of Grace",
                text = {
                    "{C:green}#1# in 2{} chance for {C:attention}4{}",
                    "random cards to gain {C:chips}+25{} Chips",
                    "permanently"
                }
            },

            co_GG_sigilwealth = {
                name = "Sigil of Wealth",
                text = {
                    "{C:green}#1# in 3{} chance to",
                    "gain {C:money}$25{}"
                }
            }
        },
    },
    misc = {
        dictionary = {
            d_downgrade = "Downgrade...",
            d_swapped = "Swapped!",
            d_cracked = "Cracked...",
            d_repaired = "Repaired!",
            d_etoh = "Etoh breaks me every day...",
            d_no_revives_left = "No Revives Left...",
            d_saved1 = "You have been saved!",
            d_saved2 = "Back on track!",
            d_saved3 = "Cheated death!",
            d_saved4 = "A second chance!",
            d_saved5 = "Revived successfully!",
            d_saved6 = "Living to see another round!",
            d_saved7 = "Death prevented!",
            d_saved8 = "Loving those cards!",
            d_saved9 = "We aren't done yet!",
            d_saved10 = "No dying yet!",
            d_steel = "Steel",
            d_freeze = "Undone :(",

            c_gn = "gooodsoups",
            c_chemn = ".chemicalized",
            c_frostn = "frostbitesmile",
            c_sein = "mamamica01",
            c_ysfn = "y_s_f19",
            c_agun = "agustosbocegi",

            c_gd = "the great noodle",
            c_chemd = "certified dumbass",
            c_frostd = "apparently likes isaac game",
            c_seid = "etoh breaks me too much",
            c_ysfd = "rolled way too many wheels",
            c_agud = "walter my beloved",

            sc_eremeln = "eremel & other contributors",
            sc_eremeld = "developed this excellent SMODS framework",

            sc_communityn = "#modding-dev",
            sc_communityd = "thanks a lot you all"
        },

        labels = {
            GG_reflective = "Reflective",
            GG_bronze = "Bronze",
            GG_tainted = "Tainted",
            GG_rusty = "Rusty",
            GG_rotten = "Rotten",
            GG_weak = "Weak"
        }
    }
}
# Datarens på valgdata, grønland 1989 (Rigsarkivets hjemmeside)

df <- readRDS("Undervisningsdokumenter/E24/slides/data/GL_vaelger_adfaerd_1989.rds")

# Assuming your dataset is loaded into a dataframe called 'df'
# Rename the variables based on the provided names

library(dplyr)

df <- df %>%
  rename(
    V1_DDAs_Undersoegelsesnr = V1,
    V4_Sprog_Ved_Udfyldelse = V4,
    V5_Resp_Oekonomisk_Situation_Sidste_2_Aar = V5,
    V6_Resp_Oekonomisk_Situation_Naeste_2_Aar = V6,
    V7_Foretrukne_Flag = V7,
    V8_Samarbejde_Inuit_Norden = V8,
    V9_Spiritusrestriktioner = V9,
    V10_Valgintention_Hvis_Valg = V10,
    V11_Grund_Til_At_Stemme = V11,
    V12_Naestbedste_Parti = V12,
    V13_Stemt_Ved_Kommunevalg_89 = V13,
    V14_Stemte_Ved_Kommunevalg_89 = V14,
    V15_Ikke_Stemte_Ved_Kommunevalg = V15,
    V16_Landstingsvalg_87_Ja_Nej = V16,
    V17_Stemt_Ved_Landstingsvalg_87 = V17,
    V18_Ej_Stemt_Ved_Landstingsvalg = V18,
    V19_Landstingssamarbejde = V19,
    V20_Groenlands_Problemer = V20,
    V21_Landsstyreformand = V21,
    V22_Skrevet_Laeserbreve = V22,
    V23_Landstings_Kommunevalg = V23,
    V24_Politikerkontakt = V24,
    V25_Demonstrationer = V25,
    V26_Opstillet_Ved_Valg = V26,
    V27_Blokader_Eller_Besaettelser = V27,
    V28_Diskuteret_Politik = V28,
    V29_Medlem_Af_Politisk_Parti = V29,
    V30_Forsoegt_At_Overtale = V30,
    V31_SIKs_Fremtid = V31,
    V32_Antallet_Af_Tilkaldte = V32,
    V33_Uranholdige_Mineraler = V33,
    V34_Sundhedsvaesnet = V34,
    V35_ArbejdsMoral = V35,
    V36_Rejefiskeriets_Prioritet = V36,
    V37_Progressiv_Skat = V37,
    V38_De_Amerikanske_Baser = V38,
    V39_Hjemmestyre_I_10_Aar = V39,
    V40_Koen = V40,
    V41_Alder_Ikke_Grupperet = V41,
    V42_Alder_Grupperet = V42,
    V43_Bosted = V43,
    V44_Kommune = V44,
    V45_Flyttet_De_Sidste_5_Aar = V45,
    V46_Flyttet_Hvorfra = V46,
    V47_Foedested = V47,
    V48_Aegtestand = V48,
    V49_Aegtefaelles_Foedested = V49,
    V50_Boet_I_Groenland = V50,
    V51_Bor_Her_Om_5_Aar = V51,
    V52_Flyttet_Om_5_Aar = V52,
    V53_Maaske_Flyttet_Om_5_Aar = V53,
    V54_Stoerrelse_Paa_Husstand = V54,
    V55_Husstandsmedlemmer_Over_20_Aar = V55,
    V56_Erhverv = V56,
    V57_Erhvervssektor = V57,
    V58_Ansaettelsesforhold = V58,
    V59_Aegtefaelles_Erhverv = V59,
    V60_Aegtefaelles_Ansaettelsesforhold = V60,
    V61_Uddannelse = V61,
    V62_Personlig_Indkomst_1988 = V62,
    V63_Husstandsindkomst_1988 = V63,
    V64_Sprog = V64,
    V65_Etnisk_Tilknytning = V65,
    V66_Alder_5_Aars_Interval = V66,
    V67_Personlig_Indkomst = V67,
    V68_Husstands_Indkomst = V68,
    V69_Sydkredsen = V69,
    V70_V74 = V70,
    V71_Diskokredsen = V71,
    V72_Yderdistrikterne = V72
  )

# Save the dataset with the new variable names
saveRDS(df, "Undervisningsdokumenter/E24/slides/data/GL_vaelger_adfaerd_1989.rds")


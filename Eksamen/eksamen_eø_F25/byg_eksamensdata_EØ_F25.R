################################################################################
#            Genererer datasæt til eksamensopgave EØ F2025 
################################################################################
set.seed(2025)  # For reproducerbare resultater

# Antal observationer
n <- 2500

# Hustype (kun Lejlighed, Rækkehus, Villa)
hustype <- sample(c("Lejlighed", "Rækkehus", "Villa"), size = n, replace = TRUE, prob = c(0.4, 0.35, 0.25))

# Byggeår og husets alder
byggeår <- round(2025 - abs(rnorm(n, mean = 20, sd = 15)))  # Normalfordelt mod nyere boliger
byggeår <- pmax(byggeår, 1950)  # Ingen byggeår før 1950
husets_alder <- 2025 - byggeår  # Husets alder i år

# Afstand til offentlig transport (i meter, realistisk fordelt)
afstand_off_transport <- round(rlnorm(n, meanlog = 6, sdlog = 0.5))
afstand_off_transport <- pmin(afstand_off_transport, 5000)  # Ingen ekstreme outliers

# Fjernvarme (Mest sandsynligt i nyere boliger og i lejligheder/rækkehuse)
fjernvarme <- ifelse(runif(n) < (0.7 - husets_alder / 150), 1, 0)
fjernvarme <- factor(fjernvarme, levels = c(0,1), labels = c("Nej", "Ja"))

# Energiklasse som simpel kategorisk variabel (ikke dummier)
energiklasse <- cut(byggeår,
                    breaks = c(1950, 1975, 1990, 2005, 2015, 2025),
                    labels = c("E", "D", "C", "B", "A"),
                    include.lowest = TRUE)

# Justering af kvadratmeterpris baseret på byggeår, afstand og hustype
grundpris <- rnorm(n, mean = 32000, sd = 3000)  # Basispris
pris_justering_byggeår <- (byggeår - 1950) * 50  # Nyere byggeri → højere pris
pris_justering_transport <- -afstand_off_transport * runif(n, min = 2, max = 4)  # Afstand reducerer pris

# Hustype påvirker også prisniveauet
pris_hustype <- rep(0, n)
pris_hustype[hustype == "Lejlighed"] <- 2000
pris_hustype[hustype == "Rækkehus"] <- 2100 + rnorm(sum(hustype == "Rækkehus"), mean = 0, sd = 200)  # Næsten lig Lejlighed
pris_hustype[hustype == "Villa"] <- 5000 + rnorm(sum(hustype == "Villa"), mean = 0, sd = 500)  # Dyrest

# Beregn endelig kvadratmeterpris
kvadratmeterpris <- grundpris + pris_justering_byggeår + pris_justering_transport + pris_hustype
kvadratmeterpris <- pmax(kvadratmeterpris, 20000)  # Sikrer realistisk minimum

# Opret datasættet som en data frame
boligdata_nuuk <- data.frame(
  kvadratmeterpris,
  afstand_off_transport,
  husets_alder,
  hustype = factor(hustype, levels = c("Lejlighed", "Rækkehus", "Villa")),
  energiklasse = factor(energiklasse, levels = c("A", "B", "C", "D", "E")),  # Bevarer ordnede kategorier
  fjernvarme
)

# Se de første rækker
head(boligdata_nuuk)


library(tidyverse)
boligdata_nuuk <- boligdata_nuuk %>% mutate(
  lejlighed = ifelse(hustype=="Lejlighed",1,0),
  rækkehus = ifelse(hustype=="Rækkehus",1,0),
  villa = ifelse(hustype=="Villa",1,0))

# Rækkefølge på variable
library(dplyr)

boligdata_nuuk <- boligdata_nuuk[, c("kvadratmeterpris", "energiklasse", "afstand_off_transport",
                                     "fjernvarme", "husets_alder", "hustype", "lejlighed", "rækkehus", "villa")]

# Gem datasættet som en RDS-fil
saveRDS(boligdata_nuuk, "C:/Users/mmn/Dropbox/Ilisimatusarfik/Eksamen/eksamen_eø_F25/Eksamensdata_EØ_F25.rds")


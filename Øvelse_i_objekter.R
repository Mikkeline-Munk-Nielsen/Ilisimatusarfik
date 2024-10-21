# Øvelse i objekter:

# Her er mit navn
navn <- "Mikkeline"

# Her er min alder
alder <- 27


# Her indlæses firma-datasættet
df_firma <- readRDS("firma_data.rds")

View(df_firma)

names(df_firma)


# Installér tidyverse
install.packages("tidyverse")

library(tidyverse)
library(dplyr)


# Lav en ny variabel, der måler omsaetning i 1.000 kr
df_firma <- df_firma %>% mutate(omsaetning_1000 = omsaetning/1000)


# Lav en dikotom variabel der tager værdien 1, hvis firmaerne har erklæret sig “tilfreds” eller “meget tilfreds” med deres omsætning, ellers skal den tage værdien 0
df_firma <- df_firma %>%
  mutate(tilfreds_binear = ifelse(tilfredshed %in% c("Tilfreds", "Meget tilfreds"), 1, 0))

# Lav et nyt datasæt kun med virksomheder fra sundhedsindustrien
df_sunhed <- df_firma %>% filter(industri=="Sundhed")


# Lav et nyt datasæt kun med firmaer, der har erklæret sig “tilfreds” eller “meget tilfreds” med deres omsætning (dvs. firmaer med værdien 1 på den variabel I lavede ovenfor)
df_sunhed <- df_firma %>% filter(tilfreds_binear==1)







################################################################################
#               Udkast til besvarelse af reeksamen for SAMF Feb. 2025
################################################################################
setwd("C:/Users/mmn/Dropbox/Ilisimatusarfik/Eksamen/reeksamen_samf")
df <- readRDS("Reeksamensdata_samf_Feb2025.rds")


# Opgave 5
###############################
# b) Lav en frekvenstabel for variablen polintr 

library(janitor)  
min_tabel <- tabyl(df, pol_int)

library(writexl) 
write_xlsx(list("Min tabel" = min_tabel), "tabel_5b.xlsx")


# c) Lav et søjlediagram (univariat barplot) for variablen polintr

library(ggplot2)

ggplot(df) +
  aes(x = factor(pol_int)) +  # Omform cyl til en kategorisk variabel
  geom_bar(fill = "#003366") +
  labs(
    title = "Politisk interesse i Norge",
    x = "Politisk interesse",
    y = "Antal respondenter"
  ) +
  theme_minimal()


# Opgave 6
###############################

# a) Beregn median, middelværdi/gennemsnit og standardafvigelse for 
#    variablen tillid_fn

library(tidyverse)
library(haven)

summary(df$tillid_fn)

sd(df$tillid_fn, na.rm = TRUE)

# b) Beregn et 95% konfidensinterval for variablens middelværdi. Beskriv resultatet
# og forklar hvordan det kan fortolkes.

t.test(df$tillid_fn)



# Opgave 7
###############################
# b) Gennemfør t-testen i R. Du skal bruge variablene tillid_fn og kon.

# Udfør t-test
ttest_resultat_bivariat <- t.test(tillid_fn ~ kon, data = df)

# Opret en tabel med resultaterne
(ttest_tabel_bivariat <- data.frame(
  Parameter = c("Gennemsnit Gruppe 1",        # Gennemsnit for første gruppe
                "Gennemsnit Gruppe 2",        # Gennemsnit for anden gruppe
                "Test-statistik",             # Teststatistikken (t-værdien)
                "P-værdi",                    # P-værdien
                "Nedre konfidensinterval",    # Nedre konfidensinterval
                "Øvre konfidensinterval",     # Øvre konfidensinterval
                "Frihedsgrader"),             # Frihedsgrader (df)
  Værdi = c(
    round(ttest_resultat_bivariat$estimate[1], 2),     # Gennemsnittet for første gruppe afrundet til 3 decimaler
    round(ttest_resultat_bivariat$estimate[2], 2),     # Gennemsnittet for anden gruppe afrundet til 3 decimaler
    round(ttest_resultat_bivariat$statistic, 3),       # Teststatistikken afrundet til 3 decimaler
    sprintf("%.4f", ttest_resultat_bivariat$p.value),  # P-værdien med 4 decimaler
    round(ttest_resultat_bivariat$conf.int[1], 3),     # Nedre konfidensinterval afrundet til 3 decimaler
    round(ttest_resultat_bivariat$conf.int[2], 3),     # Øvre konfidensinterval afrundet til 3 decimaler
    round(ttest_resultat_bivariat$parameter, 1)        # Frihedsgrader afrundet til 1 decimal
  )
))

write_xlsx(list("t-test" = ttest_tabel_bivariat), "tabel_7b.xlsx")


# Opgave 8
###############################
# a) Lav en krydstabel mellem kon  og pol_int.

library(janitor)

krydstabel <- tabyl(df, kon, pol_int) %>% 
  adorn_totals(where = c("row", "col")) %>% 
  adorn_percentages() %>% 
  adorn_pct_formatting(digits = 1)

write_xlsx(list("krydstabel" = krydstabel), "krydstabel.xlsx")




# c) Udregn den passende korrelationskoefficient for variablene kon
#    og pol_int givet deres måleniveau

krydstabel <- table(as.character(df$kon),                     
                    as.character(df$pol_int))

library(DescTools) 
CramerV(krydstabel)


# Opgave 9
###############################

# d) Brug R og eksamensdatasættet til at lave en regressionsanalyse med 
#    variablen tillid_fn som afhængig variabel, variablen kon som uafhængig 
#    variabel og variablen alder som kontrolvariabel. 

model <- lm(tillid_fn ~ kon + alder, data = df)

library(texreg)
(texreg::screenreg(list(model), include.ci=F))

texreg::wordreg(list(model), file = "9d_Regressionsresultater.doc")


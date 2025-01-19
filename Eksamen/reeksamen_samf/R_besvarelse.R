################################################################################
#               Besvarelse af reeksamen for SAMF Feb. 2025
################################################################################
setwd("C:/Users/mmn/Dropbox/Ilisimatusarfik/Eksamen/reeksamen_samf")



df <- readRDS("Reeksamensdata_samf_Feb2025.rds")


# Opgave 5 – univariat analyse

# Variablen polintr spørger til, hvor interesseret respondenter er i politik på 
# en skala fra 1 (Meget interesseret) til 5 (overhovedet ikke interesseret). 

# Lav en frekvenstabel for variablen polintr 

library(janitor)  
tabyl(df, pol_int)
library(janitor)  
tabyl(df, pol_int)

# Lav et søjlediagram (univariat barplot) for variablen polintr

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

# Variablen tillid_fn måler respondenternes tillid til De Forenede Nationer (FN) på 
# en skala fra 1 (Slet ingen tillid) til 10 (Fuldstændig tillid). Variablen 
# betragtes her som værende målt på intervalskala. 


# •	Beregn median, middelværdi/gennemsnit og standardafvigelse for variablen tillid_fn

summary(df$tillid_fn)
sd(df$tillid_fn, na.rm = TRUE)

# •	Beregn et 95% konfidensinterval for variablens middelværdi. Beskriv resultatet
# og forklar hvordan det kan fortolkes.

t.test(df$tillid_fn)




# •	Gennemfør t-testen i R. Du skal bruge variablene tillid_fn og kon.

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






# Lav en krydstabel mellem kon  og pol_int.


library(janitor)

tabyl(df, kon, pol_int)




# Udregn den passende korrelationskoefficient for variablene kon  og pol_int givet deres måleniveau

krydstabel <- table(as.character(df$kon),                     
                    as.character(df$pol_int)) 

library(DescTools) 
CramerV(krydstabel)


# Du skal nu bruge en chi-anden test for uafhængighed til formelt at teste, om der er uafhængighed eller sammenhæng mellem respondenternes køn og deres interesse for politik. 
# •	Gennemfør testen i R. Du skal bruge variablene kon  og pol_int

library(dplyr)
library(janitor)

# Udfør chi²-test
chi_resultat_bivariat <- df %>%
  select(kon, pol_int) %>%
  na.omit() %>%
  tabyl(kon, pol_int) %>%
  chisq.test()

# Opret en data frame med chi²-testens resultater
(chi_tabel_bivariat <- data.frame(
  Parameter = c("Chi²-statistik",              # Testens Chi²-statistik
                "Frihedsgrader",              # Frihedsgrader (df)
                "P-værdi"),                   # P-værdi
  Værdi = c(
    round(chi_resultat_bivariat$statistic, 3),         # Chi²-statistikken afrundet til 3 decimaler
    chi_resultat_bivariat$parameter,                   # Frihedsgrader
    sprintf("%.4f", chi_resultat_bivariat$p.value)    # P-værdien formatteret til 4 decimaler
  )))




# •	Brug R til at lave en regressionsanalyse med variabelen tillid_fn som afhængig
# variabel, variablen  kon som uafhængig variabel og variablen alder som kontrolvariabel. 


library(broom)

model <- lm(as.numeric(tillid_fn) ~ kon + alder, data = df)
tidy(model)

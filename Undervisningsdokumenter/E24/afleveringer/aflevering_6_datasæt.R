setwd("C:/Users/mmn/Dropbox/Ilisimatusarfik/Undervisningsdokumenter/E24/afleveringer")

# Sæt seed for reproducerbare resultater
set.seed(2025)

# Antal observationer
n <- 2000



# Generering af variabler
alder <- sample(18:74, size = n, replace = TRUE)  # Alder mellem 18 og 74 år
indkomst <- round(rnorm(n, mean = 42, sd = 12))  # Indkomst i 1000 DKK (månedlig)

# Køn som kategorisk variabel
køn <- sample(c("Mand", "Kvinde"), size = n, replace = TRUE, prob = c(0.5, 0.5))

# Leveringstid som gensidigt udelukkende kategorier
leveringstid_categories <- c("1-2 uger", "2-4 uger", "4 uger +")
leveringstid <- sample(leveringstid_categories, size = n, replace = TRUE, prob = c(0.3, 0.4, 0.3))

# Opret dummy-variabler for leveringstid
leveringstid_dummies <- model.matrix(~ leveringstid - 1)
colnames(leveringstid_dummies) <- c("levering_1_2_uger", "levering_2_4_uger", "levering_4_uger_plus")

# Forbrug som en funktion af indkomst, alder og leveringstid
# Stærkere korrelation mellem forbrug og indkomst samt signifikant forskel mellem leveringstider

temp_data <- data.frame(leveringstid_dummies)
forbrug <- round(
  3000 +  # Justeret basisværdi
    3.0 * indkomst +  # Forstærket sammenhæng med indkomst
    -50 * alder +  # Stærk negativ effekt af alder
    temp_data$levering_1_2_uger * 800 +  # Større forskel mellem 1-2 uger og 4+ uger
    temp_data$levering_2_4_uger * 700 + 
    temp_data$levering_4_uger_plus * 50 + 
    rnorm(n, mean = 0, sd = 1500)  # Yderligere reduceret støj for stærkere sammenhæng
)

# Sikrer, at forbrug ikke er negativt
forbrug <- pmax(forbrug, 500)

# Samler datasættet
datasæt <- data.frame(
  forbrug = forbrug,
  alder = alder,
  indkomst = indkomst,
  køn = factor(køn, levels = c("Mand", "Kvinde")),
  leveringstid = factor(leveringstid, levels = leveringstid_categories),
  leveringstid_dummies
)


# Gem datasættet
saveRDS(datasæt, "online_shopping.rds")

# Se de første rækker af datasættet
head(datasæt)

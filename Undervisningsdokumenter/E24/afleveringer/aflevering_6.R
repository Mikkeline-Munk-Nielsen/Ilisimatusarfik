##################### Simuleret datasæt øvelse 6 ############################

# Sæt seed for reproducerbare resultater
set.seed(2025)

# Antal observationer
n <- 2500

# Generering af variabler
alder <- sample(18:74, size = n, replace = TRUE)  # Alder mellem 18 og 74 år
indkomst <- round(rnorm(n, mean = 500000, sd = 150000))  # Indkomst omkring 500.000 DKK med variation

# Transportmuligheder som dummier
transport_categories <- c("direkte_fly", "direkte_skib", "indirekte_fly", "indirekte_skib")
transport <- sample(transport_categories, size = n, replace = TRUE, prob = c(0.25, 0.25, 0.25, 0.25))

# Dummy-variabler
transport_dummies <- as.data.frame(model.matrix(~ transport - 1))
names(transport_dummies) <- transport_categories

# Forbrug som en funktion af indkomst, alder og transportmuligheder
forbrug <- round(
  2000 + 
    0.1 * indkomst + 
    -30 * alder + 
    transport_dummies$direkte_fly * 5000 + 
    transport_dummies$direkte_skib * 3000 + 
    transport_dummies$indirekte_fly * 2000 + 
    transport_dummies$indirekte_skib * 1000 + 
    rnorm(n, mean = 0, sd = 10000)
)

# Sikrer, at forbrug ikke er negativt
forbrug <- pmax(forbrug, 500)

# Samler datasættet
datasæt <- data.frame(
  forbrug = forbrug,
  alder = alder,
  indkomst = indkomst,
  direkte_fly = transport_dummies$direkte_fly,
  direkte_skib = transport_dummies$direkte_skib,
  indirekte_fly = transport_dummies$indirekte_fly,
  indirekte_skib = transport_dummies$indirekte_skib
)

# Gem datasættet
saveRDS(datasæt, "Forberedelsesdata_EØ_F25.rds")

# Se de første rækker af datasættet
head(datasæt)

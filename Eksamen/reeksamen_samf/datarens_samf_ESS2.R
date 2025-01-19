
################################################################################
#                    RENSNING AF ESS RUNDE 2 DATASÆT
################################################################################
pacman::p_load(tidyverse, dplyr, tidyr, haven, ggplot2, janitor, tibble, haven)
setwd("C:/Users/mmn/Dropbox/Ilisimatusarfik/Eksamen/reeksamen_samf")


df <- read_dta("C:/Users/mmn/Dropbox/Ilisimatusarfik/R/Ilisimatusarfik_Statistik_EO_F24/Data/ESS2/ESS2.dta")

tabyl(df$cntry)


# Land

df <- df %>%
  filter(cntry == "NO")

df <- df %>% select(polintr, trstun, gndr, agea)


######### Missing

missing_values <- colSums(is.na(df))
missing_df <- data.frame(variable = names(missing_values), count = missing_values)

# Plot missing values
ggplot(missing_df, aes(x = variable, y = count)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Missing Values by Variable",
       x = "Variables",
       y = "Number of Missing Values") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_text(aes(label = count), vjust = -0.3)  # Add labels on top of bars


##### Erase all missing values
columns_no_na <- c(1, 2, 3, 4)

df <- df[complete.cases(df[, columns_no_na]), ]

################################################################################
# MUTATE

# Creating a new variable with the reversed scale
df$interesse <- ifelse(df$polintr %in% 1:4, 5 - df$polintr, df$polintr)

library(dplyr)

df_clean <- df %>%
  transmute(
    pol_int = factor(case_when(
      interesse == 1 ~ "Slet ikke",
      interesse == 2 ~ "Næsten ikke",
      interesse == 3 ~ "Ret interesseret",
      interesse == 4 ~ "Meget interesseret",
      TRUE ~ NA_character_),
      levels = c("Slet ikke", "Næsten ikke", "Ret interesseret", "Meget interesseret")),
    tillid_fn = trstun,
    kon = factor(case_when(
      gndr == 1 ~ "Mand",
      gndr == 2 ~ "Kvinde",
      TRUE ~ NA_character_),
      levels = c("Mand", "Kvinde")),
    alder = agea
  )


library(haven)

df_clean <- df_clean %>%
  mutate(across(everything(), ~ {attr(.x, "label") <- NULL; .x}))

################################################################################
# Save dataset
saveRDS(df_clean, file = "C:/Users/mmn/Dropbox/Ilisimatusarfik/Eksamen/reeksamen_samf/Reeksamensdata_samf_Feb2025.rds")




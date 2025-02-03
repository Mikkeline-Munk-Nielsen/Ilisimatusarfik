---
title: "Aflevering 4: forslag til besvarelse"
format:
  html:
    css: css_etc/custom-theme-ilisimatusarfik-doc.css
    fontfamily: Calibri
    include-before-body: ../../home-button.html
  pdf:
    keep-md: true 
---





*Følgende er et forslag til besvarelse af den tredje ud af de seks obligatoriske afleveringer i faget.* *Brug det til at sammenligne med dine egne svar og diskutér med dine medstuderende.*

## Data

Download datasættet ***ESS*** på lectio.

I denne øvelse skal I prøve kræfter med et udsnit af European Social Survey (ESS), der gennemføres i 20 forskellige EU lande. European Social Survey er et samfundsvidenskabeligt forsøg på at kortlægge holdninger, overbevisninger og adfærdsmønstre hos forskellige befolkninger i Europa. Der findes mange runder med forskellige temaer, men alle spørger ind til grundlæggende socioøkonomiske variable.

## Opret et script

Start med at åbne RStudio ved at klikke på dit R-project. Opret dernæst et nyt script og gem det i samme mappe, som dit R-project. Du kan f.eks. kalde scriptet *Aflevering_4*.

-   Brug `getwd()` til at sikre dig, at du arbejder i den rigtige mappe på computeren

-   Indlæs det indbyggede datasæt i et objekt, f.eks. kaldet `df`

## Indlæs data

-   Start med at check, at både dette dokument og ESS datasættet ligger i samme mappe som dit R-project. Indlæs det med funktionen `readRDS`:




::: {.cell}

```{.r .cell-code}
getwd()
df <- readRDS("ESS.rds")
```
:::






-   Brug `filter()` funktionen til at gemme et nyt datasæt, der kun indeholder besvarelser fra DK.




::: {.cell}

```{.r .cell-code}
library(tidyverse)

df <- filter(df, land=="DK")
```
:::




-   I skal arbejde med variablene *net_indkomst*, *koen*, *udd_aar* og *ansaettelse_type*. Kør nedenstående kode for at udvælge variablene og fjerne observationer med missingværdier (NA). Vi skal fjerne missing værdier på alle de variable, som vi skal bruge for at undgå at antallet af observationer svinger fra analyse til analyse.




::: {.cell}

```{.r .cell-code}
df <- df %>% select(net_indkomst, antal_timer_arb, udd_aar) %>% na.omit()
```
:::




# Sammenhæng mellem indkomst og uddannelse

Over de næste opgaver skal I undersøge sammenhængen mellem indkomst og uddannelse.

## 1 Korrelationer

**a) Start med at definér måleniveauerne for variablene `net_indkomst` og `udd_aar`**

Begge variable kan betragtes som intervalskalerede, da afstanden mellem værdierne på variablene er konstant og meningsfuld. Det giver også mening at tale om decimaler på begge variable.

**b) Lav et bivariat scatterplot for variablene `net_indkomst` og `udd_aar`. Ser der ud til at være en sammenhæng mellem de to variable?**




::: {.cell}

```{.r .cell-code}
library(ggplot2)

ggplot(df) +
  aes(x = udd_aar, y = net_indkomst) +
  geom_point() +
  labs(
    title = "Sammenhæng mellem antal års uddannelse og indkomst",
    x = "Antal års uddannelse",
    y = "Indkomst DKK (netto)"
  ) +
  theme_minimal()
```

::: {.cell-output-display}
![](Opgave_5_files/figure-pdf/unnamed-chunk-5-1.pdf){fig-pos='H'}
:::
:::




Scatterplottet viser, at der er en tendens til at folk har en højere indkomst, desto flere års uddannelse de har, da prikkerne lægger sig i diagonalen mellem akserne (tyder på positiv korrelation).

**c) Udregn den passende korrelationskoefficient for variablene `net_indkomst` og `udd_aar`, givet deres måleniveau. Er der en sammenhæng mellem de to variabl? Hvilken retning, og hvor stærk?**

Den passende korrelationskoefficient er pearsons $r$ for to intervalskalerede variable:




::: {.cell}

```{.r .cell-code}
cor.test(df$udd_aar, df$net_indkomst)
```

::: {.cell-output .cell-output-stdout}

```

	Pearson's product-moment correlation

data:  df$udd_aar and df$net_indkomst
t = 9.4962, df = 1180, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.2126618 0.3186282
sample estimates:
    cor 
0.26645 
```


:::
:::




Korrelationskoefficienten på 0.26 indikerer, at der er en moderat/kraftig positiv sammenhæng mellem antal arbejdstimer og indkomst. Desto mere du arbejder, desto højere indkomst.

## 2 Simpel regressionsmodel

**a) Lav et bivariat scatterplot for variablene `net_indkomst` og `udd_aar`, men tilføj nu med en regressionslinje. Kommentér på plottet - forventer du at regressionen finder en sammenhæng mellem variablene? Hvorfor?**




::: {.cell}

```{.r .cell-code}
ggplot(df) +
  aes(x = udd_aar, y = net_indkomst) +
  geom_point() +
  labs(
    title = "Sammenhæng mellem antal års uddannelse og indkomst",
    x = "Antal års uddannelse",
    y = "Indkomst DKK (netto)"
  ) +
  theme_minimal() +
  geom_smooth(method = "lm", color = "blue", se = FALSE)
```

::: {.cell-output-display}
![](Opgave_5_files/figure-pdf/unnamed-chunk-7-1.pdf){fig-pos='H'}
:::
:::




Linjens hældning antyder, at der er den positive sammenhæng, som korrelationskoefficienten også viste. En flad linje uden hældning ville indikere, at der ikke var en sammenhæng.

**b) Betragt følgende regressionsmodel; hvilken variabel er den afhængige, og hvilken er den uafhængige?**

$Indkomst = \alpha+\beta_1*udd\_aar+\epsilon$

Indkomst er den afhængige variabel. Antal års uddannelse er den uafhængige variabel, som påvirker den afhængige variabel.

**c) Estimér regressionsmodellen i R**




::: {.cell}

```{.r .cell-code}
library(texreg)

model1 <- lm(net_indkomst ~ udd_aar, data = df)

(texreg::screenreg(list(model1), include.ci=F))
```

::: {.cell-output .cell-output-stdout}

```

=========================
             Model 1     
-------------------------
(Intercept)  10650.70 ***
              (619.61)   
udd_aar        395.24 ***
               (41.62)   
-------------------------
R^2              0.07    
Adj. R^2         0.07    
Num. obs.     1182       
=========================
*** p < 0.001; ** p < 0.01; * p < 0.05
```


:::
:::




**d) Hvad er fortolkningen af værdien for konstantleddet** $\alpha$

Fortolkningen af $\alpha$ er den forventede værdi på $Y$, når modellens uafhængige variable er lig 0. Dvs. den forventede indkomst for en person med 0 års uddannelse.

**e) Hvad er fortolkningen af værdien på** $\beta_1$ **koefficienten for `udd_aar`**

Fortolkningen af $\beta_1$ er den forventede stigning i den afhængige variabel, når den tilhørende uafhængige variabel (antal års uddannelse) stiger med 1. Dvs. den forventede stigning i indkomst for hvert års ekstra uddannelse.

**f) Er der en statistisk signifikant sammenhæng mellem uddannelse og indkomst?**

De tre stjerner indikerer en $p–værdi < 0.001$. På et $5\%$ signifikansniveau er der altså en signifikant sammenhæng mellem antal års uddannelse og indkomst.

**g) Hvad er den forventede indkomst for en person med 15 års uddannelse?**

$Indkomst = \alpha+\beta_1*udd\_aar+\epsilon$

$Indkomst = 10650.70+395.24*udd\_aar+\epsilon$

$Indkomst = 10650.70+395.24*15$




::: {.cell}

```{.r .cell-code}
10650.70 + 395.24*15
```

::: {.cell-output .cell-output-stdout}

```
[1] 16579.3
```


:::
:::




## 3 Multipel lineær regression

I har nu undersøgt sammenhængen mellem antal års uddannelse og indkomst i en simpel regressionsmodel. Nu skal i undersøge, om sammenhængen i virkeligheden kan forklares af andre forhold.

Djævlens advokat kunne påstå, at indkomstforskelle mellem folk med lange og kortere uddannelser primært skyldes, at folk med længe uddannelser arbejder flere timer (og derfor får udbetalt mere). I skal derfor indføre variablen "**antal_timer_arb**" som kontrolvariabel i jeres regressionsmodel for at teste, om sammenhængen mellem uddannelse og indkomst kan forklares af, at højtuddannede folk bare arbejder flere timer.

**a) Variablen "*antal_timer_arb*" måler, hvor mange timer respondenterne arbejder ugentligt. Skriv med ord, hvilket måleniveau du mener, at variablen bør have**

Variablen kan betragtes som intervalskaleret, da afstanden mellem værdierne på variablen er konstant og meningsfuld. Det giver også mening at tale om decimaler variablen.

**b) Estimér følgende regressionsmodel:** $Indkomst = \alpha+\beta_1*udd\_aar+\beta_2*antal\_timer\_arb+\epsilon$




::: {.cell}

```{.r .cell-code}
model2 <- lm(net_indkomst ~ udd_aar +antal_timer_arb, data = df)

(texreg::screenreg(list(model1, model2), include.ci=F))
```

::: {.cell-output .cell-output-stdout}

```

==========================================
                 Model 1       Model 2    
------------------------------------------
(Intercept)      10650.70 ***  2057.61 *  
                  (619.61)     (844.87)   
udd_aar            395.24 ***   362.01 ***
                   (41.62)      (38.68)   
antal_timer_arb                 251.75 ***
                                (18.14)   
------------------------------------------
R^2                  0.07         0.20    
Adj. R^2             0.07         0.20    
Num. obs.         1182         1182       
==========================================
*** p < 0.001; ** p < 0.01; * p < 0.05
```


:::
:::




**c) Beskriv med ord, hvad fortolkningen af værdien på konstantleddet** $\alpha$ **er nu**

Fortolkningen af $\alpha$ er den forventede værdi på $Y$, når alle modellens uafhængige variable (dvs. også kontrolvariable) er lig 0. Dvs. den forventede indkomst for en person med 0 års uddannelse, der arbejder 0 timer ugentligt.

**d) Beskriv med ord, hvad fortolkningen af værdien på** $\beta_1$ **koefficienten for "udd_aar" er**

Fortolkningen af $\beta_1$ er den forventede stigning i den afhængige variabel, når den tilhørende uafhængige variabel (antal års uddannelse) stiger med 1, når der kontrolleres for antal timers arbejde. Dvs. den forventede stigning i indkomst for hvert års ekstra uddannelse, når der tages højde for, hvor mange timer man arbejder ugentligt.

**e) Er der fortsat en signifikant forskel mellem antal års uddannelse og indkomst, selv når der kontrolleres for antal arbejdstimer?**

De tre stjerner indikerer en $p–værdi < 0.001$. På et $5\%$ signifikansniveau er der altså stadig en signifikant sammenhæng mellem antal års uddannelse og indkomst, når der kontrolleres for antal arbejdstimer.

**f) Beskriv med ord, hvad fortolkningen af værdien på** $\beta_2$ **koefficienten for "antal_timer_arb" er**

Fortolkningen af $\beta_2$ er den forventede stigning i den afhængige variabel, når den tilhørende uafhængige variabel (antal arbejdstimer) stiger med 1, når der kontrolleres for antal års uddannelse. Dvs. den forventede stigning i indkomst for timers ekstra arbejde ugentligt, når der kontrolleres for års uddannelse.

**g) Er der en signifikant forskel mellem antal års indkomst og antal arbejdstimer, når der kontrolleres for antal års uddannelse?**

De tre stjerner indikerer en $p–værdi < 0.001$. På et $5\%$ signifikansniveau er der altså en signifikant sammenhæng mellem antal arbejdstimer og indkomst, når der kontrolleres for antal års uddannelse.

## 4 Forudsagte værdier

**a) Beregn den forventede indkomst for en person med 13 års uddannelse, der arbejder 40 timer ugentligt**

$Indkomst = \alpha+\beta_1*udd\_aar+\beta_2*antal\_timer\_arb+\epsilon$

$Indkomst = 2057.61+362.01*udd\_aar+251.75*antal\_timer\_arb+\epsilon$

$Indkomst = 2057.61+362.01*13+251.75*40$




::: {.cell}

```{.r .cell-code}
2057.61+(362.01*13)+(251.75*40)
```

::: {.cell-output .cell-output-stdout}

```
[1] 16833.74
```


:::
:::




**b) Beregn den forventede indkomst for en person med 18 års uddannelse, der arbejder 40 timer ugentligt**

$Indkomst = \alpha+\beta_1*udd\_aar+\beta_2*antal\_timer\_arb+\epsilon$

$Indkomst = 2057.61+362.01*udd\_aar+251.75*antal\_timer\_arb+\epsilon$

$Indkomst = 2057.61+362.01*18+251.75*40$




::: {.cell}

```{.r .cell-code}
2057.61+(362.01*18)+(251.75*40)
```

::: {.cell-output .cell-output-stdout}

```
[1] 18643.79
```


:::
:::

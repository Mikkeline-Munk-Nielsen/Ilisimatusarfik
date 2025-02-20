---
title: "Aflevering 5: forslag til besvarelse"
format:
  html:
    css: css_etc/custom-theme-ilisimatusarfik-doc.css
    fontfamily: Calibri
    include-before-body: ../../home-button.html
  pdf:
    keep-md: true 
---




*Følgende er et forslag til besvarelse af den femte ud af de seks obligatoriske afleveringer i faget.* *Brug det til at sammenligne med dine egne svar og diskutér med dine medstuderende.*

## Opret et script

Start med at åbne RStudio ved at klikke på dit R-project. Opret dernæst et nyt script og gem det i samme mappe, som dit R-project. Du kan f.eks. kalde scriptet *Aflevering_5*.

## Data

I denne øvelse skal I arbejde videre med European Social Survey (ESS datasættet). I skal derfor ikke downloade et nyt datasæt.

-   Start med at check, at ESS datasættet ligger i samme mappe som dit R-project.




::: {.cell}

```{.r .cell-code}
getwd() # Denne kommando fortæller dig, hvilken mappe du arbejder i lige nu.
```

::: {.cell-output .cell-output-stdout}

```
[1] "C:/Users/mmn/Dropbox/Ilisimatusarfik/Undervisningsdokumenter/E24/afleveringer"
```


:::

```{.r .cell-code}
setwd("C:/Users/mmn/Dropbox/Ilisimatusarfik/Undervisningsdokumenter/E24/slides/data")

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




-   I skal arbejde med variablene net_indkomst, koen, udd_aar og ansaettelse_type. Kør nedenstående kode for at udvælge variablene og fjerne observationer med missingværdier (NA):




::: {.cell}

```{.r .cell-code}
df <- df %>% select(net_indkomst, koen, udd_aar, ansaettelse_type) %>% na.omit()
```
:::




## Sammenhæng mellem køn og indkomst

Over de næste opgaver skal I undersøge sammenhængen mellem køn og indkomst.

### Opgave 1: simpel lineær regression

**a) Start med at lav en tabel over variablen koen (køn).**




::: {.cell}

```{.r .cell-code}
library(janitor)
df %>% tabyl(koen)
```

::: {.cell-output .cell-output-stdout}

```
   koen   n   percent
   Mand 617 0.5197978
 Kvinde 570 0.4802022
```


:::
:::




**b) Skriv med ord, hvilket måleniveau du mener, at variablen koen bør være på**

*En variabel der måler køn i to kategorier, mand og kvinde, bør have nominelt måleniveau, da det ikke er meningsfuldt at rangordne eller tale om meningsfulde afstande mellem kategorierne. Man kan også beskrive den som en dikotom variabel, da den kun tager to værdier.*

**c) Lav to dummy-variable, en for hver af kategorierne på variablen *koen***




::: {.cell}

```{.r .cell-code}
df <- df %>% mutate(
mand = ifelse(koen=="Mand",1,0),
kvinde = ifelse(koen=="Kvinde",1,0))
```
:::




I skal nu undersøge sammenhængen mellem køn og indkomst med lineær regressionsanalyse.

**d) Kig på den nedenståene formel for model 1. Skriv med ord, hvilken variabel der er den afhængige, og hvilken variabel, der er den uafhængige:**

Model 1: $indkomst = \alpha+\beta_1*kvinde+\epsilon$

*Indkomst er den afhængige variabel og "kvinde" er den uafhængige. Den afhængige variabel noteres altid til venstre for lighedstegnet, og de uafhængige til højre.*

**e) Estimér model 1**




::: {.cell}

```{.r .cell-code}
model1 <- lm(net_indkomst ~ kvinde, data = df)

library(texreg)
(texreg::screenreg(list(model1), include.ci=F))
```

::: {.cell-output .cell-output-stdout}

```

=========================
             Model 1     
-------------------------
(Intercept)  16977.70 ***
              (328.66)   
kvinde       -1802.47 ***
              (474.28)   
-------------------------
R^2              0.01    
Adj. R^2         0.01    
Num. obs.     1187       
=========================
*** p < 0.001; ** p < 0.01; * p < 0.05
```


:::
:::




**f) Hvad er fortolkningen af værdien for konstantleddet** $\alpha$**?**

*Konstantleddet alpha / intercept er den forventede værdi på den afhængige variabel indkomst, når alle uafhængige variable er lig 0. Dvs. Intercept beskriver den forventede indkomst for en person, der har 0 på den uafhængige variabel kvinde - med andre ord den forventede indkomst for mænd.*

**g) Hvad er fortolkningen af værdien på parameterestimatet for "kvinde" (**$\beta_1$**)?**

$\beta_1$ *beskriver ændringen i den afhængige variabel "Indkomst" for én enhedsændring i den uafhængige variabel "Kvinde". Dvs. den beskriver den forventede ændring i indkomst, når variablen "kvinde" går fra 0 til 1 - med andre ord, når man går fra værdien "mand" til "kvinde". Kvinder ser altså ud til gennemsnitligt at have en nettoindkomst på 1802 kroner mindre end mænd.*

**h) Er der en statistisk signifikant sammenhæng mellem køn og indkomst?**

*Vi kan aflæse den statistiske sammenhæng mellem dummyvariablen "kvinde" og "indkomst" ved at kigge på stjernerne ud for parameterestimatet. Tre stjerner ud fra parameterestimatet for* $\beta_1$ *indikerer, at p-værdien er under 0,001.* *Den er derfor under vores statistiske grænseværdi på 0,05, hvilket betyder, at der ser ud til at være en statistisk signifikant sammenhæng mellem en køn og indkomst - kvinder ser ud til gennemsnitligt at tjene signifikant mindre end mænd (1802 kroner mindre).*

<br>

Nu skal du sætte koefficienterne fra dit resultat ind i formlen for regressionsmodellen for at udregne følgende:

**i) Hvad er den forventede indkomst for en mand?**

*Regressionsligningen er givet ved:*

$indkomst = \alpha+\beta_1*kvinde+\epsilon$

*Den forventede indkomst for en mand er således givet ved:*

$indkomst _{mand}= 16978-1803*0=16978+0=16978$

*Da mænd tager værdien 0 på den uafhængige dummyvariabel "kvinde".*

**j) Hvad er den forventede indkomst for en kvinde?**

*Den forventede indkomst for en kvinde er givet ved:*

$indkomst _{kvinde}= 16978-1803*1=16978-1803=15175$

*Da kvinder tager værdien 1 på den uafhængige dummyvariabel "kvinde".*

<br>

### Opgave 2: multipel lineær regression (forlæns modelsøgning)

I har nu undersøgt sammenhængen mellem køn og indkomst i en simpel regressionsmodel. Nu skal I undersøge, om sammenhængen i virkeligheden kan forklares af andre faktorer.

Nogle påstår, at lønforskellen på mænd og kvinder skyldes, at mænd gennemsnitligt set har mere uddannelse end kvinder. I skal derfor indføre variablen "udd_aar" som kontrolvariabel i jeres regressionsmodel for at teste, om forskellen i indkomst mellem mænd og kvinder kan forklares af, at mænd gennemsnitligt tager flere års uddannelse end kvinder.

**a) Variablen "udd_aar" måler, hvor mange års uddannelse respondenterne har. Skriv med ord, hvilket måleniveau du mener, at variablen bør have**

*En variabel der måler antal års uddannelse må være intervalskaleret, da det giver mening at rangordne værdierne og afstanden mellem værdierne er konstante og meningsfulde.*

<br>

I skal nu undersøge, om sammenhængen mellem køn og indkomst kan forklares af forskelle i antal års uddannelse med følgende model:\
\
Model 2: $indkomst = \alpha+\beta_1*kvinde+\beta_2*udd\_aar+\epsilon$

**b) Estimér model 2**




::: {.cell}

```{.r .cell-code}
model2 <- lm(net_indkomst ~ kvinde + udd_aar, data = df)

(texreg::screenreg(list(model1, model2), include.ci=F))
```

::: {.cell-output .cell-output-stdout}

```

=======================================
             Model 1       Model 2     
---------------------------------------
(Intercept)  16977.70 ***  11506.14 ***
              (328.66)      (649.18)   
kvinde       -1802.47 ***  -1926.81 ***
              (474.28)      (457.02)   
udd_aar                      398.91 ***
                             (41.32)   
---------------------------------------
R^2              0.01          0.08    
Adj. R^2         0.01          0.08    
Num. obs.     1187          1187       
=======================================
*** p < 0.001; ** p < 0.01; * p < 0.05
```


:::
:::




**c) Beskriv med ord, hvad fortolkningen af værdien på konstantleddet** $\alpha$ **er nu**

*Konstantleddet alpha / intercept er den forventede værdi på den afhængige variabel indkomst, når alle uafhængige variable er lig 0. Intercept beskriver altså nu den forventede indkomst for en person, der har 0 på den uafhængige variabel "kvinde" OG på den uafhængige variabel "antal års uddannelse"- med andre ord den forventede indkomst for mænd med 0 års uddannelse.*

**d) Beskriv med ord, hvad fortolkningen af værdien på parameterestimatet** $\beta_2$ **for "udd_aar" er**

$\beta_2$ *beskriver ændringen i den afhængige variabel indkomst for én enhedsændring i den uafhængige variabel "antal års uddannelse". Dvs. den beskriver den forventede ændring i indkomst, når variablen "antal års uddannelse" stiger med 1 - med andre ord, når man får et års uddannelse mere. Det ser altså ud til, at man gennemsnitligt kan forvente en stigning i netto indkomst på 399 DKK, for hvert års ekstra uddannelse, som man tager.\
\
Da vi har at gøre med en multipel model nu (mere en én uafhængig variabel) er der dog en ekstra fortolkningsmæssig pointe.* $\beta_2$ *beskriver ændringen i indkomst, når antal års uddannelse stiger med 1, når værdien på den anden uafhængige variabel "kvinde" holdes konstant. Med andre ord beskriver* $\beta_2$ *ændringen i indkomst, når antal års uddannelse stiger med 1 og der samtidig kontrolleres for køn. I praksis svarer det til, at vi kigger på "effekten" af et års uddannelse, når vi kun sammenligner mænd med mænd og kvinder med kvinder. På den måde er vi sikre på, at den forskel i indkomst vi observerer, når vi skruer på antal års uddannelse, skyldes uddannelse og ikke underliggende forskelle mellem køn.*

**e) Er der en signifikant sammenhæng mellem antal års uddannelse og indkomst?**

*Vi kan aflæse den statistiske sammenhæng mellem variablen "antal års uddannelse" og "indkomst" ved at kigge på stjernerne for parameterestimatet* $\beta_2$ *tilhørende variablen "udd_aar". Tre sterner indikerer en p-værdi \< 0,001, hvilket er den under vores statistiske grænseværdi på 0,05. Der ser således ud til at være en statistisk signifikant sammenhæng mellem indkomst og antal års uddannelse, også når der tages højde for køn. Jo flere års uddannelse man har, desto mere ser man ud til at tjene (399 DKK kroner mere for hvert år, i gennemsnit).*

**f) Er der fortsat en signifikant forskel mellem køn og indkomst, selv når der kontrolleres for antal aars uddannelse?**

*Vi kan aflæse den statistiske sammenhæng mellem variablen "kvinde" og "indkomst" ved at kigge på p-værdien for parameterestimatet* $\beta_1$ *tilhørende variablen "kvinde". Tre stjerner indikerer en p-værdi \< 0,001, hvilket er under vores statistiske grænseværdi på 0,05. Det betyder, at der ser ud til at stadig være en statistisk signifikant sammenhæng mellem indkomst og køn. Kvinder ser faktisk ud til gennemsnitligt at tjene 1927 DKK mindre end mænd, når vi har kontrolleret for forskelle i antal års uddannelse. Vi undervurderede altså forskellen i den forrige model.*

<br>

Andre påstår, at lønforskellen på mænd og kvinder skyldes, at mænd har andre typer af ansættelse end kvinder har. I skal derfor indføre variablen "ansaettelse_type" som endnu en kontrolvariabel i jeres regressionsmodel for at teste, om sammenhængen mellem køn og indkomst kan forklares af forskelle i *ansættelsestyper*.

**g) Lav en tabel over variablen "ansættelses_type" for at undersøge, hvilke ansættelsestyper variablen indeholder.\
**




::: {.cell}

```{.r .cell-code}
tabyl(df$ansaettelse_type)
```

::: {.cell-output .cell-output-stdout}

```
 df$ansaettelse_type    n    percent
         Lønmodtager 1129 0.95113732
         Selvstændig   54 0.04549284
             Familie    4 0.00336984
```


:::
:::




*Tabellen viser, at vi har tre kategorier "lønmodtager", "selvstændig", og "familie" (hjemmegående). Der er dog kun 4 observationer i kategorien "familie". Dette gør den i princippet uegnet til statistisk analyse. Når vi har meget små antal observationer ved vi, at den statistiske usikkerhed bliver meget stor. I dette tilfælde indkluderer vi den dog for eksemplets skyld.*

**h) Skriv med ord, hvilket måleniveau du mener, at variablen ansaettelse_type bør være på\
*dit svar***

*En variabel der måler ansættelsestyper såsom "lønmodtager", "selvstændig", og "familie" må være nominal, da kategorierne ikke kan rangordnes. Der er heller ikke meningsfuld afstand mellem dem.*

**i) Lav tre dummy variable, en for hver kategori på variablen ansaettelse_type**




::: {.cell}

```{.r .cell-code}
df <- df %>% mutate(
  loenmodtager = ifelse(ansaettelse_type=="Lønmodtager",1,0),
  selvstaending = ifelse(ansaettelse_type=="Selvstændig",1,0),
  familie = ifelse(ansaettelse_type=="Familie",1,0)
)
```
:::




I skal nu undersøge om sammenhængen mellem køn og indkomst kan forklares af antal års uddannelse eller ansættelsestype. Kig på formlen nedenfor for model 3. \
\
Model 3: $indkomst = \alpha+\beta_1*kvinde+\beta_2*udd\_aar+\beta_3*selvstændig+\beta_4*familie+\epsilon$

**h) Hvilken ansættelses-kategori er udeladt som referencekategori? Og hvilket køn?**

*Kategorien "lønmodtager" er udeladt som referencekategori for ansættelsestype og kategorien "mand" er udeladt som referencekategori for køn.*

**j) Estimér model 3**




::: {.cell}

```{.r .cell-code}
model3 <- lm(net_indkomst ~ kvinde + udd_aar + selvstaending + familie, data = df)

(texreg::screenreg(list(model1, model2, model3), include.ci=F))
```

::: {.cell-output .cell-output-stdout}

```

=======================================================
               Model 1       Model 2       Model 3     
-------------------------------------------------------
(Intercept)    16977.70 ***  11506.14 ***  11619.77 ***
                (328.66)      (649.18)      (652.22)   
kvinde         -1802.47 ***  -1926.81 ***  -1940.44 ***
                (474.28)      (457.02)      (459.26)   
udd_aar                        398.91 ***    396.31 ***
                               (41.32)       (41.31)   
selvstaending                               -983.83    
                                           (1100.27)   
familie                                    -7826.67 *  
                                           (3938.99)   
-------------------------------------------------------
R^2                0.01          0.08          0.09    
Adj. R^2           0.01          0.08          0.08    
Num. obs.       1187          1187          1187       
=======================================================
*** p < 0.001; ** p < 0.01; * p < 0.05
```


:::
:::




**k) Beskriv med ord, hvad fortolkningen af værdien på konstantleddet er nu**

*Konstantleddet alpha / intercept er den forventede værdi på den afhængige variabel "indkomst", når alle uafhængige variable er lig 0. Konstantleddet/intercept beskriver altså nu den forventede indkomst for en person, der har 0 på den uafhængige variabel "kvinde" OG den uafhængige variabel "antal års uddannelse" OG den uafhængige variabel "Selvstændig" OG den uafhængige variabel "Familie".\
\
Med andre ord beskriver konstantleddet nu den forventede indkomst for mænd med 0 års uddannelse, som er lønmodtagere. "Lønmodtager" bliver nemlig referencekategorien for de to dummyvariable "selvstændig" og familie", da det er den kategori på variablen "ansættelsestype", der bliver ekskluderet fra modellen. Da de tre kategorier er gensidigt udelukkede, er man per definition lønmodtager, hvis man har 0 på dummyvariablen "selvstændig" og på dummyvariablen "familie".*

**l) Beskriv med ord, hvad fortolkningen af værdien på koefficienten for ansættelsestypen "Selvstændig" er:**

*Parameterestimatet for dummy variablen "selvstændig" beskriver den forventede forskel/ændring i den afhængige variabel "indkomst", mellem referencekategorien "lønmodtager" og kategorien "selvstændig", når der kontrolleres for køn og antal års uddannelse. Selvstændige ser altså ud til gennemsnitligt at tjene 984 DKK mindre end lønmodtagere. Da der ikke er nogle stjerner på parameterestimatet er p-værdien \>= 0,05. Der ser altså ikke ud til at være en statistisk signifikant forskel på indkomsten mellem lønmodtagere og selvstændige, når der kontrolleres for køn og antal års uddannelse.*

**m) Beskriv med ord, hvad fortolkningen af værdien på koefficienten for ansættelsestypen "Familie" er**

*Parameterestimatet for dummy variablen "familie" beskriver den forventede forskel/ændring i den afhængige variabel "indkomst", mellem referencekategorien "lønmodtager" og kategorien "familie", når der kontrolleres for køn og antal års uddannelse. Den ene stjerne indikerer, at p-værdien \< 0,05. Der er altså faktisk en signifikant forskel i indkomst på folk, der er hjemmegående og lønmodtagere på trods at det lave (!) antal observationer i denne kategori. Folk der arbejder i familien ser altså ud til gennemsnitligt at tjene 7827 DKK mindre end lønmodtagere.* *Med andre ord er forskellene så systematiske, at vi med mindre en 5% risiko for type-I fejl kan sige, at forskellen kan genfindes i populationen.*

**n) Er der fortsat en signifikant forskel mellem koen og indkomst, selv når der kontrolleres for antal aars uddannelse OG ansættelsestype? Skriv med ord.**

*De tre stjerner for parameterestimatet for* $\beta_1$ indikerer, at *p-værdien tilhørende variablen "kvinde" er under 0,001. Dette er under vores kritiske grænse på 0,05 og vi kan konkludere at forskellen/sammenhængen er statistisk signifikant. Kvinder tjener gennemsnitligt 1940 DKK mindre om måneden end mænd, når der kontrolleres for antal års uddannelse og ansættelsestype.*

### Opgave 3: forklaringskraft

I har nu undersøgt sammenhængen mellem køn og indkomst via. forlæns modelsøgning. I har estimeret tre forskelige modeller:

*Model 1: simpel model kun med afhængig og uafhængig variabel (indkomst og køn)*

*Model 2: multipel model med én kontrolvariabel (indkomst, køn og antal års uddannelse)*

*Model 3: multipel model med to kontrolvariable (indkomst, køn, antal års uddannelse og ansættelsestype).*

I skal nu sammenligne de tre modeller for at afgøre, hvilken en der har den højeste forklaringskraft ved at sammenligne de tre modellers $R^2$ værdi.

<br>

**a) Skriv med ord, hvad** $R^2$ **værdien fortæller os**

$R^2$ *værdien er et udtryk for, hvor meget af variationen i den afhængige variabel, de uafhængige variabler kan forklare. Der er altså et mål for, hvor god vores model er til at forklare variation/forskelle i vores afhængige variabel indkomst.*

**b) Sammenlign dine modellers** $R^2$ **værdi. Hvilken model har den højeste forklaringskraft?**




::: {.cell}

```{.r .cell-code}
(texreg::screenreg(list(model1, model2, model3), include.ci=F))
```

::: {.cell-output .cell-output-stdout}

```

=======================================================
               Model 1       Model 2       Model 3     
-------------------------------------------------------
(Intercept)    16977.70 ***  11506.14 ***  11619.77 ***
                (328.66)      (649.18)      (652.22)   
kvinde         -1802.47 ***  -1926.81 ***  -1940.44 ***
                (474.28)      (457.02)      (459.26)   
udd_aar                        398.91 ***    396.31 ***
                               (41.32)       (41.31)   
selvstaending                               -983.83    
                                           (1100.27)   
familie                                    -7826.67 *  
                                           (3938.99)   
-------------------------------------------------------
R^2                0.01          0.08          0.09    
Adj. R^2           0.01          0.08          0.08    
Num. obs.       1187          1187          1187       
=======================================================
*** p < 0.001; ** p < 0.01; * p < 0.05
```


:::
:::




*Model 3 ser ud til at have den højeste* $R^2$ *værdi og dermed forklaringskraft. Kigger man dog på* den justerede $R^2$ *værdi (Adj. R\^2), som kun inkluderer forklaringskraften blandt de variable, der bidrager signifikant til modellen, så er forklaringskraften i model 2 og 3 ens.*

**c) Skriv med ord, hvor stor en del af variationen i indkomst kan den bedste model forklare?**

*Tilsammen kan alle variablene i model tre forklare 9 % af variationen i den afhængige variabel indkomst. Kigger man på den justerede* $R^2$ *værdi (Adj. R\^2), så forklarer model 2 og 3 begge 8 % af variationen i den afhængige variabel indkomst.* *Det er altså ikke helt klart, om model 3 faktisk har en højere forklaringskraft end model 2.*

### Opgave 4: F-test for to modeller

Man kan sammenligne, hvilke modeller der er bedst, ved at sammenligne deres forklaringskraft. Men der skal en hypotesetest til at afgøre, om én model har en signifikant højere forklaringskraft end en anden.

Når man sammenligner to modellers forklaringskraft, hvor der er mere end ét parameterestimat til forskel – som her, hvor model 2 og 3 har både parameterestimatet for ansættelsestypen "familie" og ansættelsestypen "selvstændig" til forskel – skal man altid benytte F-testen. F-testen kan nemlig teste, om den forklaringskraft, som flere variable tilsammen tilføjer, er signifikant forskellig fra 0.

**a) Opstil hypoteserne for F-testen mellem model 2 og model 3 med ord:**\
\
*H0: forklaringskraften i model 3 er ikke signifikant højere end i model 2*

*H1: forklaringskraften i model 3 er signifikant højere end i model 2*

**b) Kør en F-test mellem model 2 og model 3**




::: {.cell}

```{.r .cell-code}
f_test <- anova(model2, model3)

(f_test_summary <- data.frame(
  "Forskel i Frihedsgrader" = f_test$Df[2],        # Forskel i frihedsgrader
  "F-statistik" = f_test$F[2],                     # F-statistik
  "P-værdi" = sprintf("%.4f", f_test$`Pr(>F)`[2]), # P-værdi med 4 decimaler
  check.names = FALSE))
```

::: {.cell-output .cell-output-stdout}

```
  Forskel i Frihedsgrader F-statistik P-værdi
1                       2    2.358291  0.0950
```


:::
:::




**c) Konkludér på testen. Forklarer model 3 signifikant mere end model 2?**

*Da vi får en p-værdi på 0,095 overskrider den vores grænse på 0,05. Vi kan altså ikke afvise nulhypotesen og konkludere, at model 3 forklarer signifikant mere end model 2. Dette giver mening, da forskellen på model 2 og model 3 kun var dummierne for ansættelsestype. Variablen "selvstændig" var insignifikant og variablen "familie" kun lige akkurat signifikant (en stjerne). Vi kan med denne F-test ikke konkludere, at ansættelsestype-dummierne tilsammen bidrager med nogen signifikant forklaringskraft til modellen, og de kan derfor i princippet udelades fra modellen.*


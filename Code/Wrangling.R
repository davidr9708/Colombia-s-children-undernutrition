# Packages
library(tidyverse)
library(gganimate)


# Data frame 
load(file = "Undernutrition.rda")
load(file = "Rdata/Demography.rda")


# Cleaning and summarizing data frames
Demography.summary <-  Demography %>%
    filter(P_EDADR == 1) %>%
    mutate(SEXO = fct_recode(as.factor(P_SEXO), Hombre = "1", Mujer = "2"), 
                  .keep ="unused") %>%
    rename(COD_DPTO_R = "U_DPTO") %>%
    group_by(COD_DPTO_R, SEXO, PA1_GRP_ETNIC) %>%
    summarise(Total.dpto = n())
  
Undernutrition.summary <-  Undernutrition %>%
    mutate(SEXO = fct_recode(SEXO, Hombre = "M", Mujer = "F")) %>%
    group_by(COD_DPTO_R,Departamento_residencia, SEXO) %>%
    summarise(Total.cases = n())


# Joining data frames
Rates <- 
  inner_join(Demography.summary, Undernutrition.summary) %>%
  ungroup(.) %>%
  mutate(Colombia.rate = (sum(Total.cases)/sum(Total.dpto))*1000) %>%
  group_by(Departamento_residencia) %>%
  summarise(Colombia.rate = mean(Colombia.rate),
            Rate = (sum(Total.cases)/sum(Total.dpto))*1000) %>%
  mutate(Departamento_residencia = str_to_title(Departamento_residencia),
         Departamento_residencia = fct_reorder(Departamento_residencia, Rate),
         Ranking = rank(desc(Rate)), 
         TOP.10 = ifelse(Ranking < 11, "Highest", "Lowest")) %>%
  arrange(desc(Ranking))


# Save data frame   
save(Rates, file = "Rdata/Rates.rda")



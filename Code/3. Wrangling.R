# Packages
library(tidyverse)

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
  mutate(Colombia_rate = round((sum(Total.cases)/sum(Total.dpto))*1000),2) %>%
  group_by(Departamento_residencia) %>%
  summarise(Colombia_rate = mean(Colombia_rate),
            Rate = round((sum(Total.cases)/sum(Total.dpto))*1000, 2)) %>%
  mutate(Departamento_residency = str_to_title(Departamento_residencia),
         Departamento_residency = fct_reorder(Departamento_residency, Rate),
         Ranking = rank(desc(Rate)), 
         TOP_10 = ifelse(Ranking < 11, "Yes", "No")) %>%
  arrange(desc(Ranking)) %>%
  select(Departamento_residency, Rate, Colombia_rate, Ranking, TOP_10) 



# Save data frame   
save(Rates, file = "Rdata/Rates.rda")

# Export data frame as a CSV file
write.csv(Rates, "Colombia_children_5_undernutrition_rates_2018.csv")



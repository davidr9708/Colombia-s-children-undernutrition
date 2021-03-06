# Packages
library(tidyverse)


# Data frame 
load(file = "Rdata/Rates.rda")

# Plot
Rates %>%
  ggplot(aes(y = Departamento, x = Rate, 
             fill = TOP_10, label = round(Rate, 0))) + 
  
  ## Geom
  geom_bar(stat = "identity", width = 0.8) +
  geom_text(color = "white", hjust = 1.5) +
  geom_hline(yintercept = 17.5, linetype = "dashed", color = "black") +
  
  ## Titles and annotations 
  ggtitle(" Desnutrición en niños menores de 5 años,\nranking de los departamentos colombianos (2018)") + 
  xlab("Tasa de desnutrición por cada 1000 niños menores de 5 años") + ylab("")+
  annotate("text",label = "Por encima de la tasa de Colombia", x = 130, y = 18, 
           color = "black")+
  annotate("text",label = "Por debajo de la tasa de Colombia", x = 130, y = 17, 
           color = "black")+
  
  ## Scales
  scale_x_continuous(expand = c(0,0)) +
  scale_fill_manual(values = c("darkgray", "darkred")) +
  
  ## Theme
  theme(plot.margin = unit(c(0.6, 0.8, 0, 0), "cm"),
        plot.title = element_text(vjust = 5, hjust = -0.12, face = "bold"),
        axis.title.x = element_text(vjust = 213, hjust = 0, color = "black"),
        axis.text.y = element_text(color = ifelse(Rates$TOP_10 == "Yes", "darkred", "darkgray")),
        axis.ticks = element_blank(), axis.text.x = element_blank(),
        legend.position = "none",
        panel.background = element_blank())



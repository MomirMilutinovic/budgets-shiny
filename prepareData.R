library(tidyverse)
library(readxl)

# Import data
kg_prihod <- read_xlsx("data/kg-budzet-2020-plan-prihoda.xlsx")
kg_rashod <- read_xlsx("data/kg-budzet-2020-plan-rashoda.xlsx")
pb_prihod <- read_xlsx("data/otvoreni-budzet-planirani-prihodi-opstina-priboj-2020.xlsx")
pb_rashod <- read_xlsx("data/otvoreni-budzet-planirani-rashodi-opstina-priboj-2020.xlsx")
ni_prihod <- read_xlsx("data/otvoreni-budzhet-planirani-prikhodi-grad-nish.xlsx")
ni_rashod <- read_xlsx("data/otvoreni-budzhet-planirani-raskhodi-grad-nish.xlsx")

# Take a look at the data
glimpse(kg_prihod)
gllimpse(kg_rashod)
glimpse(pb_prihod)
glimpse(pb_rashod)
glimpse(ni_prihod)
glimpse(ni_rashod)

pripremi_prihod_rashod <- function(prihod, rashod, city)
{
  # Returns the earining and spending data in a cleaner and easier-to-use format
  # with a city column for differentiating it in a fused dataset
  prihod <- prihod %>% select(c(Назив_класе, Назив_категорије, Назив_групе, Назив_економске_класе, Средства_из_буџета, Средства_из_cопствених_извора, Средства_из_осталих_извора))
  rashod <- rashod %>% select(c(Назив_програма, Назив_програмске_класификације, Назив_функције, Назив_економске_класификације, Средства_из_буџета, Средства_из_сопствених_извора, Средства_из_осталих_извора))
  
  prihod <- prihod %>% mutate_all(~replace(., is.na(.), 0))
  rashod <- rashod %>% mutate_all(~replace(., is.na(.), 0))
  
  # Mark spending as such by making the numbers negative
  rashod <- rashod %>% mutate_at(c("Средства_из_буџета", "Средства_из_сопствених_извора", "Средства_из_осталих_извора"),
                                 function(x){x * -1})
  
  names(prihod)[1:7] <- c("klasa", "kategorija", "grupa", "ekonomska_klasa", "budzet", "sopstveni_izvori", "ostali_izvori")
  names(rashod)[1:7] <- c("program", "programska_klasifikacija", "funkcija", "ekonomska_klasifikacija", "budzet", "sopstveni_izvori", "ostali_izvori")
  
  prihod <- prihod %>% mutate(grad = city)
  rashod <- rashod %>% mutate(grad = city)
  
  ret_list <- list(prihod, rashod)
  names(ret_list) <- c("prihod", "rashod")
  ret_list
}

kg <- pripremi_prihod_rashod(kg_prihod, kg_rashod, "Kragujevac")

names(pb_rashod)[6] <- "Назив_програмске_класификације"
names(ni_rashod)[8] <- "Назив_програмске_класификације"
pb <- pripremi_prihod_rashod(pb_prihod, pb_rashod, "Priboj")
ni <- pripremi_prihod_rashod(ni_prihod, ni_rashod, "Nis")

write.csv(rbind(kg$prihod, pb$prihod, ni$prihod), "data/prihodi.csv")
write.csv(rbind(kg$rashod, pb$rashod, ni$rashod), "data/rashodi.csv")





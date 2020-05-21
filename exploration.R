library(tidyverse)

prihodi <- read_csv("data/prihodi.csv")
rashodi <- read_csv("data/rashodi.csv")



prihodi <- prihodi %>% filter(grad == "Kragujevac") %>% group_by(ekonomska_klasa)
rashodi <- rashodi %>% filter(grad == "Kragujevac") %>% group_by(ekonomska_klasifikacija)
klasa_budzet <- summarise(prihodi, budzet = sum(budzet))
klasa_budzet <- klasa_budzet %>% top_n(n = 5) %>% arrange(desc(budzet))


klasa_budzet_rashod <- summarise(rashodi, budzet = sum(budzet))
klasa_budzet_rashod <- klasa_budzet_rashod %>% top_n(n = 5) %>% arrange(desc(budzet))

barplot(height=klasa_budzet$budzet,
        col="#69b3a2",
        names.arg=klasa_budzet$ekonomska_klasa,
        las=2 
)
klasa_budzet %>% ggplot(aes(x=ekonomska_klasa, y=budzet)) +
  geom_col() +
  theme(text = element_text(size=12),
        axis.text.x = element_text(angle=45, hjust = 1))

klasa_budzet_rashod %>% ggplot(aes(x=ekonomska_klasifikacija, y=budzet)) +
  geom_col() +
  theme(text = element_text(size=12),
        axis.text.x = element_text(angle=45, hjust = 1))
#' Figure 3a: JPE loss - compare genetic and LAD loss estimates
#' @description Barplot comparing JPE loss: genetic vs LAD loss estimates.
#' Currently using a flat file provided by BOR that will be updated once genetic data
#' is shared with SacPas. The LAD loss data is imported directly from SacPas.
#' @return static barplot comparing JPE loss: genetic v LAD loss estimates
#' @import ggplot2
#' @import dplyr
#' @import here
#' @noRd

#import data file
## Genetic total loss data
load(here("data/jpe_genetic_loss_data.rda"))
genetic_total_loss_data <- jpe_genetic_loss_data$genetic_total_loss_data
## LAD total loss data
load(here("data/jpe_lad_loss_data.rda")) 
lad_total_loss_data <- jpe_lad_loss_data$lad_total_loss_data

# Merge genetic and LAD loss data
jpe_genetic_lad_data <- genetic_total_loss_data %>% 
  mutate(method = "Genetic") %>% 
  bind_rows(lad_total_loss_data %>% 
              mutate(method = "LAD") %>% 
              filter(between(WY, 1996, 2024))) %>% #filter to match genetic data years provided by BOR
  pivot_longer(cols = c(pct_total_loss, total_loss),
               names_to = "value_type",
               values_to = "value")

#bar plot of genetic and LAD loss
p <- jpe_genetic_lad_data %>% 
  filter(value_type == "total_loss") %>% 
  ggplot(aes(x=as.factor(WY), y= value, fill=method)) +
  geom_bar(stat="identity", position=position_dodge(preserve = "single"))+
  labs(title = "Genetic vs Length-At-Date (LAD) Historical Loss of the JPE",
       x = "Water Year", 
       y = "Number of fish loss",
       fill = NULL) +
  scale_y_continuous(expand = c(0, 0))+
  scale_fill_manual(values = c("black", "grey"),
                    # breaks = c("count_gen", "count_lad"),
                    labels = c("Genetic", "LAD"))+
  theme_minimal() +
  theme(legend.position = "right", 
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5),
        panel.grid.major.x = element_blank(), 
        axis.line.x = element_line(color = "black", .5),
        axis.ticks.x = element_line(color = "black"), 
        text = element_text(size = 15))

print(p)


#Notes:
#currently missing 2007 JPE data from SacPas
#No 2005 genetic data
#filter WY data to match genetic data years provided by BOR
#plot by BY or WY?
#' @title Winter- run Chinook Hatchery Percent Confirmed Loss
#' @import ggplot2
#' @import dplyr
#' @import scales
#' @import here
#' @import patchwork
#' 

# import data file
# loss data from sacpas
load(here("data/winter_run_chinook_hatchery_loss_data.rda"))

current_year<-year(today())


#bar plot of genetic and LAD loss
p1 <- winter_run_chinook_hatchery_loss_data %>% 
  ggplot(aes(x=as.factor(WY), y= x_loss_of_cwt_number_released)) +
  geom_bar(stat="identity", position=position_dodge())+
  labs(title = "Confirmed Percent Loss of CWT Fish Released at SWP & CVP Facilities",
       x = "Water Year", 
       y = "Percent loss",
       fill = NULL) +
  scale_y_continuous( labels = scales::percent_format() , expand = c(0, 0))+
  theme_minimal() +
  theme(legend.position = "right", 
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5),
        panel.grid.major.x = element_blank(), 
        panel.grid.minor.y = element_blank(), 
        axis.line.x = element_line(color = "black", .5),
        axis.ticks.x = element_line(color = "black"), 
        text = element_text(size = 15))

p2 <- winter_run_chinook_hatchery_loss_data %>% 
  ggplot(aes(x=as.factor(WY), y= cwt_number_released)) +
  geom_bar(stat="identity", position=position_dodge())+
  labs(title = "Winter-run Chinook Hatchery Fish Released",
       x = "Water Year", 
       y = "Number released",
       fill = NULL) +
  scale_y_continuous(labels = scales::comma,  expand = c(0, 0))+
  theme_minimal() +
  theme(legend.position = "right", 
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5),
        panel.grid.major.x = element_blank(), 
        panel.grid.minor.y = element_blank(), 
        axis.line.x = element_line(color = "black", .5),
        axis.ticks.x = element_line(color = "black"), 
        text = element_text(size = 15))


p <- p1 / p2

print(p)


#' @title Size Distribution of Clipped and Non-clipped Steelhead Loss By Year
#' @description This plot shows the size distribution by year of the clipped and non-clipped steelhead loss.
#' @import ggplot2
#' @import scales
#' @import dplyr
#' @import here
#' 

# load data
load(here("data/steelhead_loss_data.rda"))


#plot
p <- steelhead_loss_data %>% 
  filter(length < 750) %>%  #set limit for length -- why 750 seems big?
  # filter(WY > 2004) %>% #why filtering WY after 2004?
  ggplot(aes(x = length, y = factor(WY))) +
  geom_density_ridges( aes(fill = adipose_clip, color = adipose_clip), scale = 1.5, draw_baseline = FALSE) +
  labs(x = 'Fork Length (mm)', 
       y = 'Water Year', 
       subtitle = "Historical Steelhead size distribution by rear type", 
       fill = NULL, color = NULL) +
  scale_fill_manual(values = c("grey30", adjustcolor("grey70", alpha.f = .7))) +
  scale_color_manual(values = c("grey30", "grey70")) +
  # facet_wrap(~adipose_clip, ncol = 1) +
  theme_minimal() +
  theme(text = element_text(size = 15),
        legend.position = "bottom",
        panel.border= element_rect(color = "grey80", fill = NA), 
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(), axis.ticks = element_line(size = .25, color = "grey80"))

print(p)
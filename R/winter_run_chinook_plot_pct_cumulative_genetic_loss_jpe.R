#' Figure 3b: Winter-run Chinook JPE Cumulative Genetic Percent Loss
#' @description This script includes shared genetic data from BOR to plot the cumulative genetic loss of the JPE for the current water year compared to historical years. 
#' The current water year is black and the past years are grey. Could Include color by hydrological water year type.
#' @details The data is sourced from `data` > `jpe_genetic_loss_data.rda > genetic_cumulative_loss_data` and is wrangled in `data-raw` > `import_winter_run_chinook_genetic_loss_data.R`.
#' @return A static plot comparing the cumulative genetic loss of the JPE for the current water year compared to historical years.

require(tidyverse)
require(here)
require(scales)
require(gghighlight)
require(ggrepel)

# import data file
load(here("data/jpe_genetic_loss_data.rda"))

# extract genetic cumulative loss data
genetic_cumulative_loss_data <- jpe_genetic_loss_data$genetic_cumulative_loss_data

# import wDay to month function
source(here("R/utils_fct_wday_to_month.R"))

#set current year
source(here("R/utils_fct_assign_current_water_year.R"))
current_year <- assign_current_water_year()

# calculate the maximum pct_cumloss for the current year
max_pct_cumloss_current_year <- genetic_cumulative_loss_data %>%
  filter(WY == current_year) %>%
  group_by(WY) %>% 
  summarise(max_pct_cumloss = max(pct_cumloss)) %>%
  pull(max_pct_cumloss)

#extract maximum pct_cumloss for each year (for labels)
max_pct_cumloss_per_year <-genetic_cumulative_loss_data %>%
  group_by(WY) %>%
  filter(pct_cumloss == max(pct_cumloss))

# filter data for the year 2001 (for year label and max value label)
year2001_data <- genetic_cumulative_loss_data %>% filter(WY == 2001, pct_cumloss < .01)
maxvalue2001<- genetic_cumulative_loss_data %>% 
  filter(WY == 2001) %>% 
  summarise(maxvalue = max(pct_cumloss)) %>% 
  pull(maxvalue)

#plot all years together  
p <- genetic_cumulative_loss_data %>% 
  #remove values greater than 1% for better visualization
  filter(pct_cumloss < .01) %>%
  ggplot() +
  geom_line( data = . %>% filter( WY != current_year), aes(x=wDay, y = pct_cumloss, group = WY ), lwd = 1)+ #color = hydro_type_grp
  geom_line( data = . %>% filter( WY == current_year), aes( x=wDay, y = pct_cumloss, group = WY, linetype = as.factor(WY)), color = "#0072B2", lwd = 2)+
  geom_line(aes(x = 1, y = 0, color = paste0(min(genetic_cumulative_loss_data$WY), " to ", current_year-1, ",\nWY > WY", current_year,  " loss labelled")),  data = data.frame(x = NA), show.legend = TRUE) +
  labs(x = 'Date', 
       y = 'Percent Cumulative Loss', 
       title = 'Current and Historical Percent Cumulative Genetic Loss of JPE',
       subtitle = paste0("Species: Natural Winter-run Chinook\nData Years: WY", min(genetic_cumulative_loss_data$WY), " to WY", current_year),
       caption = "Genetic loss data provided by USBR before Water Year 2020;\nLAD and genetic loss data sourced from the CDFW Salvage Database.",
       color = "Historical Water Years:",
       linetype = "Current Water Year:") +
  scale_x_continuous(breaks = seq(1, 365, by = 61), labels = wDay_to_month( seq(1, 365, by = 61))) +
  scale_y_continuous(labels = scales::percent_format(), expand=c(0,0.0003)) +
  gghighlight(WY == current_year, use_direct_label = FALSE, label_key = WY) +
  # scale_color_manual(values = c("sienna4", "steelblue4", "grey"), 
  #                    labels = c("Below Normal, Dry, & Critical", "Wet & Above Normal", "WY2023, unassigned"))+ #look into automating naming for NA
  scale_color_manual(values = "grey") +
  ggrepel::geom_text_repel(data = max_pct_cumloss_per_year %>% 
                                  filter(pct_cumloss >= max_pct_cumloss_current_year & WY !=2001), 
                           aes(x = wDay, y = pct_cumloss, label = WY), #, color = hydro_type_grp
                           size = 3,
                           force = 1,
                           nudge_x = 20,
                           nudge_y = .0005,
                           hjust = 0,
                           direction = "y",
                           segment.size = .2 ) +
  geom_text(data = year2001_data, 
            aes(x = 160, y = .0098, label = paste0("*2001\nmax value = ", round(maxvalue2001*100, 2), " %")), 
            size = 3, fontface = "plain") +
  guides(linetype = guide_legend(order = 1), color = guide_legend(order = 2, override.aes = aes(label = ""))) + #override to remove "a" from geom_text_repel in legend
  theme_minimal() +
  theme(legend.position = "bottom", 
        text = element_text(size = 15),
        panel.grid.major = element_line(linetype = "dotted"),
        panel.border = element_rect(colour = "black", fill = NA, size = 1),
        axis.ticks = element_line(size = 0.5),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()
        )


print(p)

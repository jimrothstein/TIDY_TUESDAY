---
title: "Making a bar chart with direct labels and a call out"
subtitle: "Featuring experimental ggwipe and geom_bar_callout()"
author: "Evangeline Reynolds"
date: "`r Sys.Date()`"
output: 
  html_document:
    toc: TRUE
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
options(tidyverse.quiet = TRUE)

```


# Data Cleaning

```{r}
library(tidyverse)
coffee_survey <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-14/coffee_survey.csv')

coffee_survey$age %>% 
  unique() %>% 
  sort() ->
alphabetical_age; alphabetical_age

age_cats <- alphabetical_age[c(1,3:7, 2)]

```

# Plot 1: A basic bar chart


```{r}
# 31
coffee_survey |>
dplyr::filter(is.na(age)) |> count()


# 4011

coffee_survey |>
  dplyr::filter(!is.na(age)) |> 
  ggplot() + 
  aes(y = factor(age, age_cats)) + 
  geom_bar() + 
  labs(title = "Number of respondents in each\nage category in the 'coffee survey'") +
  labs(tag = "Plot 1")

# hist(factor(coffee_survey$age))

coffee_survey |>
  dplyr::filter(!is.na(age) |>
  ggplot(age) + 
  aes(y = factor(age)) + 
  geom_bar() + 
  labs(title = "Number of respondents in each\nage category in the 'coffee survey'") +
  labs(tag = "Plot 1")
```


# Plot 2: some thematic adjustment

```{r}
last_plot() + 
  # change y axis labels
  scale_y_discrete(breaks = age_cats, 
                   labels = age_cats |> 
                     str_replace(" years old", "yrs")) + 
  # theme and labs adjustments
  theme_minimal(base_size = 18) + 
  theme(panel.grid.major.y = element_blank()) + 
  theme(panel.grid.minor.y = element_blank()) + 
  theme(plot.title.position = "plot") +
  labs(y = NULL)  + 
  labs(tag = "Plot 2")
```

# Plot 3: direct labels - using 'label' geom in stat_count to control spacing

you may be tempted to get padded "text" layer using hjust = -.2, won't give you consistent padding if you have variable length text for your labels.

```{r}
last_plot() + 
  aes(label = after_stat(count)) +
  stat_count(geom = "label", 
             hjust = 0, 
             size = 5) +
  scale_x_continuous(expand = expansion(c(0, .12))) + 
  labs(tag = "Plot 3")
```

# Plot 4: Now remove "label" layer (used for demonstration purposes), replace with one where label.size = NA



```{r}
ggwipe::last_plot_wipe_last() + 
  stat_count(geom = "label", 
             hjust = 0, 
             alpha = .8,
             label.size = NA 
             ) + 
  labs(tag = "Plot 4")
```

# Plot 5: remove bar layer, replace with colorful, slightly transparent layer


```{r}
ggwipe::last_plot_wipe(index = 1) + # remove bar layer 
  geom_bar(fill = "seagreen4", alpha = .7) + 
  labs(tag = "Plot 5")
```

# Plot 6: An experiment with a callout layer.  

### function preparation

```{r, warning=F}
bar_callout <- function(data, 
                             nudge_y = 0,
                             nudge_x = 0, 
                             quantile_x = .5,
                             quantile_y = .5, ...){
  
  callout_aes <- aes(x = quantile(c(xmin, xmax), quantile_x) + nudge_x,
                   y = quantile(c(ymin, ymax), quantile_y) + nudge_y,
                   label = label %>% str_wrap(30),
                   xend = quantile(c(xmin, xmax), quantile_x),
                   yend = quantile(c(ymin, ymax), quantile_y))
  
  
  list(
    geom_label(mapping = callout_aes, data = data, ...),
    geom_curve(mapping = callout_aes, data = data, ...)
       )
  
}
```

## Use in plot

```{r, warning=F}
my_callout <- "25-35 year olds are well represented in this survey.  With almost two thousand respondents, it has more than double the number of respondents than any other age category."

last_plot() +
  bar_callout(data = layer_data(plot = last_plot(), # looking at data 
                                i = 2) %>% #that is used to draw bar layer (now second layer in plot)
                .[3,], # and specifically the third bar in series
                   quantile_x = .55, # where does curve emanate from in bar
                   quantile_y = .8,
                   nudge_y = 1.5, # How far in y should text be away
                   nudge_x = 200, 
                   label = my_callout %>% str_wrap(27), 
             vjust = .3,
             hjust = 0,
             color = "grey35", curvature = .1) + 
  labs(x = NULL) +
  labs(tag = "Plot 6")
```  

x=c(0,.5)
y=c(0, .8)
ggplot_data = tibble(x,y)
ggplot(ggplot_data, aes(x = x, y = y)) + geom_path()

library(tidyverse)
library(palmerpenguins)

penguins


## https://juliasilge.com/blog/palmer-penguins/

## Classification?   male or female

## not quite clean separation
penguins %>%
  dplyr::filter(!is.na(sex)) %>%
  ggplot(aes(flipper_length_mm, bill_length_mm, color = sex, size = body_mass_g)) +
  geom_point(alpha = 0.5) +
  facet_wrap(~species) # one for each


dim(penguins)
# [1] 344   8

# 11
penguins %>%
  dplyr::filter(is.na(sex)) |>
  count()

## remove year, island and omit rows without sex
penguins_df <- penguins %>%
  dplyr::filter(!is.na(sex)) %>%
  select(-year, -island)

dim(penguins_df)
# [1] 333   6


# -------------------
library(tidymodels)
# -------------------

## these are not tibbles
set.seed(123)
penguin_split <- initial_split(penguins_df, strata = sex) # 3/4 1/4
penguin_train <- training(penguin_split)
penguin_test <- testing(penguin_split)


# take samples (bootstraps) of training
set.seed(123)
penguin_boot <- rsample::bootstraps(penguin_train)
penguin_boot

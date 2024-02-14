historical_spending <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/historical_spending.csv")
gifts_age <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/gifts_age.csv")
gifts_gender <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/gifts_gender.csv")


L <- c("historical_spending", "gifts_age", "gifts_gender")

## get environment correct !
# lapply(L, f)


## save data
f <- function(table) {
  name <- paste0(substitute(table))
  saveRDS(table, file = paste0(substitute(table), ".RDS"))
}
f(historical_spending)
f(gifts_age)
f(gifts_gender)
dir()


## same but lapply
lapply(L, f)
lapply(L, g)

g <- function(table, name = deparse(substitute(table))) {
  browser()
  saveRDS(table, file = paste0(name, ".RDS"))
}
##
rm(L) # from memory
ls()

## retrieve from saved RDS files
historical_spending <- readRDS(file = "historical_spending.RDS")
gifts_age <- readRDS(file = "gifts_age.RDS")
gifts_gender <- readRDS(file = "gifts_gender.RDS")

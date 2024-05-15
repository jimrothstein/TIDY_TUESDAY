
working_dir
## READ

coffee_survey <- readr::read_csv(paste0(working_dir, "/", "coffee_survey.csv"))
C  <- coffee_survey
head(coffee_survey)




.age = C |>
dplyr::group_by(age) |>
count()
hist(.age$n)



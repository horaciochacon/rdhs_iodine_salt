library(tidyverse)
library(sjlabelled)
library(rdhs)

# Config setup
config <- yaml::read_yaml('config.yaml', readLines.warn = FALSE)
vars <- config$variables

# Obtain list of datasets, surveys and Peru DHS
datasets <- read_rds("data/dhs_datasets.rds")
surveys <- read_rds("data/surveys.rds")
country_list <- read_csv("input/country_list.csv")
peru <- read_rds("input/peru.rds")

# Get variables from prior variable specification vector
variables <- search_variables(datasets$FileName, variables = vars) 
  
variables_spread <- variables %>% 
  select(dataset_filename,variable) %>% 
  spread(variable, variable)

# We generate the extract list with all datasets
extract <- extract_dhs(questions = variables, add_geo = FALSE)

extract <- extract %>% 
  map(
    ~ .x %>% 
      mutate(
        across(
          any_of("hv234"),
          ~ case_when(
          .x %in% c(15, 30) ~ 1,
          .x %in% c(0,7) ~ 0
          )
        ),
        across(
          any_of("hv234a"),
          ~ case_when(
            .x == 1 ~ 1,
            .x == 0 ~ 0
            )
          )
        )
  )

# We append all processed datasets
final <- bind_rows(extract) 

# We mutate the outcome variable and filter the dataset
final <- final %>% 
  as_tibble() %>% 
  filter(SurveyId != "IA2020DHS", SurveyId != "PE2012DHS", hv101_01 == 1) %>% 
  bind_rows(peru) %>% 
  mutate(iodine = ifelse(is.na(hv234a), hv234, hv234a)) %>% 
  filter(iodine %in% c(0,1)) %>% 
  mutate(
    DHS_CountryCode = str_sub(SurveyId,1,2),
    hv005 = hv005/1000000
    ) %>%
  left_join(surveys[,c(1:4)], by = "DHS_CountryCode") %>% 
  left_join(country_list[,c(2:3)], by = "CountryName")

final[final$CountryName == "Peru",]$SurveyYear <- "2021"

write_rds(final,"data/final.rds")
 










library(tidyverse)
library(srvyr)
library(sjlabelled)

# Obtain birth recode datasets from get_countries_datasets.R
source("src/1_get_datasets.R")

# Specify variables to include in the analysis
vars <- c("hv001", "hv022", "hv024", "hv005", "hv025", "hv270",
          "hv021","hv106_01", "hv101_01", "hv234a")

# Get variables from prior variable specification vector
variables <- search_variables(datasets$FileName, variables = vars) 
  
variables_spread <- variables %>% 
  select(dataset_filename,variable) %>% 
  spread(variable, variable)

countries_complete <- variables_spread %>% 
  na.omit() %>% 
  pull(dataset_filename)

# We generate the extract list with all datasets
extract <- extract_dhs(questions = variables, add_geo = FALSE)

# We append all procesed datasets
final <- rbind_labelled(extract[countries_complete])

# We mutate the outcome variable and filter the dataset
final <- final %>% 
  as_tibble() %>% 
  filter(hv234a %in% c(0,1), hv101_01 == 1) %>% 
  mutate(
    iodine = case_when(
      hv234a == 1 ~ 1,
      hv234a == 0 ~ 0
    ),
    DHS_CountryCode = str_sub(SurveyId,1,2),
    hv005 = hv005/1000000
    ) %>%
  left_join(surveys[,c(1:4)],
            by = "DHS_CountryCode") %>% 
  left_join(country_list[,c(2:3)], by = "CountryName")

write_rds(final,"data/final.rds")
 










library(srvyr)
library(sjlabelled)
library(tidyverse)

# Config setup
config <- yaml::read_yaml('config.yaml', readLines.warn = FALSE)

# Read appended DHS datasets
final <- read_rds("data/final.rds")

# Get survey design object with srvyr
options(survey.lonely.psu = "adjust")
design <- final %>% 
  as_survey_design(id = hv001, strata = hv022, weights = hv005, nest = TRUE) 

# Calculate estimates of outcome prevalence per country
estimates_countries <- design %>% 
  group_by_at({{config$estimates$group_direct}}) %>% 
  summarise(
    prop = survey_mean(.data[[config$estimates$outcome]], vartype = "ci")
    )

write_excel_csv(estimates_countries, "output/estimates_countries.csv")

# Calculate estimates of outcome prevalence per country per wealth quintile
estimates_wealth_quintile <- design %>% 
  group_by_at({{config$estimates$group_wealth}}) %>%  
  summarise(
    prop = survey_mean(.data[[config$estimates$outcome]], vartype = "ci")
    ) %>% 
  mutate(across(.data[[config$estimates$group_wealth[5]]], as_character)) %>% 
  rename(Wealth_Quintile = .data[[config$estimates$group_wealth[5]]])

write_excel_csv(
  estimates_wealth_quintile,"output/estimates_wealth_quintile.csv"
)

# Calculate estimates of outcome prevalence per country per urban/rural
estimates_urban_rural <- design %>% 
  group_by_at({{config$estimates$group_urb_rur}}) %>%  
  summarise(
    prop = survey_mean(.data[[config$estimates$outcome]], vartype = "ci")
  ) %>% 
  mutate(across(.data[[config$estimates$group_urb_rur[5]]], as_character)) %>% 
  rename(Residence = .data[[config$estimates$group_urb_rur[5]]])

write_excel_csv(
  estimates_urban_rural,"output/estimates_urban_rural.csv"
)

# Calculate estimates of outcome prevalence per country per education 
estimates_education_lvl <- design %>% 
  group_by_at({{config$estimates$group_edu}}) %>%  
  summarise(
    prop = survey_mean(.data[[config$estimates$outcome]], vartype = "ci")
  ) %>% 
  mutate(across(.data[[config$estimates$group_edu[5]]], as_character)) %>% 
  rename(Education = .data[[config$estimates$group_edu[5]]]) %>% 
  filter(Education %in% config$estimates$val_edu)
  
write_excel_csv(
  estimates_education_lvl,"output/estimates_education_lvl.csv"
)

# Calculate estimates for meta-analysis
estimates_meta_analysis <- design %>%
  group_by_at({{config$estimates$group_direct}}) %>%
  summarise(
    num = survey_total(.data[[config$estimates$outcome]]),
    denom = survey_total(!.data[[config$estimates$outcome]]),
    prop = survey_mean(.data[[config$estimates$outcome]],vartype = c("ci","se"))
    ) %>%
  mutate(denom = num + denom) %>%
  select_at({{config$estimates$meta_vars}})

write_excel_csv(estimates_meta_analysis, "output/estimates_meta_analysis.csv")


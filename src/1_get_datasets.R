library(rdhs)
library(tidyverse)

# Setup
config <- yaml::read_yaml('config.yaml', readLines.warn = FALSE)
project <- config$rdhs$project
source("src/0_functions.R")

## Set up your credentials
set_rdhs_config(
  project = project,
  email = config$rdhs$email,
  cache_path = config$rdhs$cache_path,
  verbose_download = TRUE
)

# Get countries last survey + SurveyId
surveys <- get_last_survey()

# Get datasets
datasets <- dhs_datasets(
  surveyIds = surveys$SurveyId,
  fileFormat = config$rdhs$surveys$fileformat,
  fileType = config$rdhs$surveys$filetype,
  surveyYearStart = config$rdhs$surveys$YearStart
) 

# Download queried datasets
dhs_datasets <- get_datasets(datasets$FileName)

# Write list of DHS datasets
write_rds(datasets, "data/dhs_datasets.rds")
write_rds(surveys, "data/surveys.rds")

# Load data for Meta-analysis
library(meta)
library(metafor)
library(ggplot2)
library(tidyverse)

# Read data
data <- read_csv("output/estimates_meta_analysis.csv") %>%
  mutate(
    num = round(num),
    denom = round(denom)
  )

data <- data %>% mutate(
  CountryName = case_when(
    CountryName == "Congo Democratic Republic" ~ "Congo (DRC)",
    CountryName == "Sao Tome and Principe" ~ "Sao Tome",
    TRUE ~ CountryName
  )
)

# Method 1: Using meta package

# Run meta-analysis
metaanalysis <- metaprop(
  event = num,
  n = denom,
  data = data,
  studlab = CountryName,
  byvar = RegionWorldBank,  # for subgroup analysis
  method = "Inverse",  
  sm = "PFT",
  method.ci = "CP",
  level = 0.95,
  fixed = FALSE,  # Random effects model
  hakn = FALSE,
  method.tau = "DL"
)

png(file = "plots/forest_plot.png", width = 2000, height = 3600, res = 300)

# Forest plot
forest(
  metaanalysis,
  sortvar = data$prop,  # Sorting variable
  comb.fixed = TRUE,  # Random effects model
  bylab = "Country Region",  # Label for subgroups
  # hetlab = "",
  print.tau2 = FALSE,
  # layout = "RevMan5",
  # col.square = "black",  # Color of squares
  digits = 1,
  digits.I2 = 0,
  digits.tau = 3,
  digits.tau2 = 3,
  digits.pval = 3,
  pscale = 100,  # Scale for proportion
  fontsize = 7,  # Font size
  spacing = 0.7,  # Space between lines
  # col.square.lines = "black",  # Color of lines around squares
  sub.group = TRUE,  # Display subgroups
  squaresize = 0.8,  # Increase the size of the squares
  leftcols = c("studlab", "event", "n"),
  rightcols = c("ci", "w.random"),
  leftlabs = c("Region/Country", "Events", "Total"),
  rightlabs = c("Events per 100\n (95% CI)", "Weight\n (%)")
)


dev.off()

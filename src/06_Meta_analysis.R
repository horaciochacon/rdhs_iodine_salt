# Load data for Meta-analysis
library(meta)
library(metafor)
library(ggplot2)

# Read data
data <- read_csv("output/estimates_meta_analysis.csv") %>% 
  mutate(
    num = round(num),
    denom = round(denom)
  )

# Run meta-analysis
metaanalysis <- metaprop(
  event = num, 
  n = denom, 
  data = data,
  studlab = CountryName,
  subgroup = RegionWorldBank,
  exclude = NULL,
  method = "Inverse",  ##One of "Inverse" and "GLMM", can be abbreviated
  sm = "PFT",
  method.ci = "CP",  ##Clopper-Pearson interval also called ’exact’ binomial interval (method.ci = "CP", default)
  level = 0.95,
  fixed = FALSE,
  hakn = F,
  method.tau = "DL"
  ) 

# Forest plot
forest(
  metaanalysis, 
  sortvar = data$prop,
  comb.fixed = FALSE, 
  bylab = "Country Region", 
  hetlab = "", 
  print.tau2 = FALSE,
  layout = "RevMan",
  col.square = "red",
  digits = 1,
  digits.I2= 0,
  digits.tau= 3,
  digits.tau2= 3,
  digits.pval = 3,
  fontsize = 6,
  spacing = 0.6,
  col.square.lines = "red"
  )

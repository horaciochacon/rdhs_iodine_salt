# Get last Survey ---------------------------------------------------------

get_last_survey <- function() {
  dhs_surveys() %>%
    filter(SurveyType == "DHS") %>%
    group_by(SubregionName, CountryName, DHS_CountryCode) %>%
    summarise(SurveyYear = max(SurveyYear)) %>%
    arrange(desc(SurveyYear)) %>%
    merge(
      dhs_surveys() %>%
        select(CountryName, SurveyYear, SurveyId),
      by = c("CountryName", "SurveyYear")
    )
}


# bind_dhs_var -----------------------------------------------------------

bind_dhs_var <- function(var_data,var, desc, data, id) {
  bind_rows(var_data,
    tibble(
      variable = var,
      description = desc,
      dataset_filename = data,
      dataset_path = paste0(
        "C:/Users/horac/Documents/R/RDHS",
        "/data/datasets/",
        data,
        ".rds"
      ),
      survey_id = id
    )
  )
}


# Dumbbell Plots ------------------------------------------------------
library(scales)

plot_dumbbell <- function(data, var, var_label, legend_label, remove_y_axis = FALSE){
  p <- ggplot(data) +
    geom_line(
      aes(x = CountryName, y = prop, group = CountryName),
      color = "gray20",
      size = .25
    ) +
    geom_point(
      aes(
        x = CountryName,
        y = prop, 
        fill = .data[[var]],
        shape = var_label
      ),
      size = 2.5
    ) +
    geom_point(
      aes(x = CountryName,
          y = prop_avg,
          shape = "National Prevalence"),
      fill = "black",
      size = 2
    ) +
    scale_fill_brewer(palette = "Set1", direction = -1) +
    scale_y_continuous(labels = percent, trans = "exp") +
    scale_shape_manual(values = c(21,23)) +
    theme_bw() +
    theme(legend.justification = c(1,0),
          legend.position = c(0.65, 0.03),
          legend.box.background = element_rect(color="black", size=0.5),
          legend.box.margin = margin(1, 1, 1, 1)) +
    coord_flip() +
    labs(
      x = "Country (survey year)",
      y = "Household salt iodine prevalence",
      fill = legend_label,
      shape = "Aggregation Level"
    ) +
    guides(
      shape = guide_legend(order = 1),
      fill=guide_legend(override.aes=list(shape=21))
    ) + 
    theme(axis.title.x = element_blank())
  
  if (remove_y_axis) {
    p <- p + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(), axis.title.y = element_blank())
  }
  
  return(p)
}



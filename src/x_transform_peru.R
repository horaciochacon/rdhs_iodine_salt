peru <- read_stata("input/Peru_2021.dta") %>% 
  janitor::clean_names() %>% 
  select(-sh224) %>% 
  mutate(
    hv106_01 = sjlabelled::as_labelled(hv106_01),
    hv024 = sjlabelled::as_labelled(hv024),
    hv025 = sjlabelled::as_labelled(hv025),
    hv270 = sjlabelled::as_labelled(hv270),
    hv234 = case_when(
      hv234 %in% c(15, 30) ~ 1,
      hv234 %in% c(0,7) ~ 0
    ),
    SurveyId = "PE2012DHS"
  )

write_rds(peru, "input/peru.rds")

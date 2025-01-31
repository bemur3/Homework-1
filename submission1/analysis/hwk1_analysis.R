if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggplot2, dplyr, lubridate, readxl, data.table, gdata, scales)

#Read data and set workspace for knitr
full_ma_data <- readRDS("data/output/ma_data.rds")
contract_service_area <- readRDS("data/output/contract_data.rds")

#objects for markdown
plan_type_table <- full_ma_data %>% group_by(plan_type) %>% count() %>% arrange(-n)
tot_obs <- as.numeric(count(full_ma_data %>% ungroup()))
plan_type_year1 <- full_ma_data %>% group_by(plan_type) %>% count() %>% arrange(-n) %>% filter(plan_type!="NA")

final_plans <- full_ma_data %>%
filter(snp == "No" & eghp == "No" &
(planid < 800 | planid > 900))
plan_type_year2 <- final_plans %>% group_by(plan_type) %>% count() %>% arrange(-n) 

plan_type_enroll <- final_plans %>% group_by(plan_type) %>% summarise(n=n(), enrollment=mean(enrollment, na_rm=TRUE)) %>% arrange(-enrollment)

final_data <- final_plans %>%
inner_join(contract_service_area %>%
select(contractid, fips, year)
by=c("contractid", "fips", "year")) %>% # nolint
filter(!is_na(enrollment))

rm(list=c("full_ma_data", "contract_service_area", "final_data"))
save.image("submission1/Hwk1_workspace.RData")
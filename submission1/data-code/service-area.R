## Read in service area data for the year 2015 only
monthlist_2015 <- c("01", "02", "03", "04", "05",
                    "06", "07", "08", "09", "10", "11", "12")
## Initialize an empty data frame to hold the year's data
service.year <- NULL # nolint

## Process each month in 2015
for (m in monthlist_2015) {
  ma.path <- paste0("data/input/monthly-ma-contract-service-area/MA_Cnty_SA_",
                    2015, "_", m, ".csv")
  service.area <- read_csv(ma.path, skip = 1,
                           col_names = c("contractid", "org_name", "org_type",
                                         "plan_type", "partial", "eghp", "ssa",
                                         "fips", "county", "state", "notes"),
                           col_types = cols(contractid = col_character(),
                                            org_name = col_character(),
                                            org_type = col_character(),
                                            plan_type = col_character(),
                                            partial = col_logical(),
                                            eghp = col_character(),
                                            ssa = col_double(),
                                            fips = col_double(),
                                            county = col_character(),
                                            notes = col_character()),
                           na = "*") %>%
    mutate(month = m, year = 2015)
  if (is.null(service.year)) {
    service.year <- service.area
  } else {
    service.year <- rbind(service.year, service.area)
  }
}

## Fill in missing fips codes and other missing data
service.year <- service.year %>%
  group_by(state, county) %>%
  fill(fips) %>%
  group_by(contractid) %>%
  fill(plan_type, partial, eghp, org_type, org_name) %>%
  group_by(contractid, fips) %>%
  mutate(id_count = row_number()) %>%
  filter(id_count == 1) %>%
  select(-c(id_count, month))

## Save the processed 2015 data
write_rds(service.year, "data/output/contract_service_area_2015.rds")

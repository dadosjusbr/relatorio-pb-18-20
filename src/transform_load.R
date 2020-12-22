#!/usr/bin/env Rscript

library(readr)
library(magrittr)
library(purrr, warn.conflicts = F)

col_types = cols(
  aid = col_character(),
  month = col_integer(),
  year = col_integer(),
  reg = col_character(),
  name = col_character(),
  role = col_character(),
  type = col_character(),
  workplace = col_character(),
  active = col_logical(),
  .default = col_double()
)

read_many_files <- function(files){
  files %>% 
    map_df(read_csv, col_types = col_types)
}

transform_incomes = function(incomes_raw) {
  incomes = incomes_raw %>%
    mutate(
      date = lubridate::ymd(paste(year, month, "01")),
      perks_except_daily = perks_total,
      perks_total = perks_total + if_else(!is.na(funds_daily) &
                                            (funds_daily > 0), funds_daily, 0),
      funds_total = funds_total - if_else(!is.na(funds_daily) &
                                            (funds_daily > 0), funds_daily, 0),
      wage = if_else(wage >= 0, wage, 0),
      discounts_ceil_retention = if_else(discounts_ceil_retention > 0, discounts_ceil_retention, 0),
      wage_disc = wage - discounts_ceil_retention,
      funds_except_rights = funds_total - if_else(is.na(funds_eventual_benefits), 0, funds_eventual_benefits),
      income_total_edr = income_total - replace_na(funds_daily, 0) - funds_eventual_benefits
    ) %>%
    mutate(wage_disc = if_else(wage_disc > 0, wage_disc, 0)) %>%
    rename(perks_daily = funds_daily)
  
  roles_tre = read_csv(here::here("dados/input/trepb-roles-types.csv"), 
                       col_types = "cdc") %>% 
    transmute(role = role, tre_type = type) 
  
  incomes = incomes %>% 
    left_join(roles_tre, by = "role") %>% 
    mutate(type = if_else(aid == "trepb", tre_type, type)) %>% 
    select(-tre_type)
  
  incomes
}


main <- function(argv = NULL) {
  input_dir <- ifelse(
    length(argv) >= 1,
    argv[1],
    here::here("dados", "raw")
  )
  
  output_file = here::here("dados", "ready", "incomes-all.csv")
  
  data_raw <- read_many_files(list.files(path = input_dir, pattern = "*.csv", full.names = T))
  
  data_ready = data_raw %>% 
    transform_incomes() 
  
  data_ready %>% 
    write_csv(output_file, na = "")
  
  message("Dados salvos em ", output_file)
}

if (!interactive()) {
  argv <- commandArgs(TRUE) 
  main(argv)
}
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

read_many_file <- function(files){
  files %>% 
    map_df(read_csv, col_types = col_types)
}

main <- function(argv = NULL) {
  input_dir <- ifelse(
    length(argv) >= 1,
    argv[1],
    here::here("dados", "raw")
  )
  
  output_file = here::here("dados", "ready", "incomes-all.csv")
  
  data_raw <- read_many_file(list.files(path = input_dir, pattern = "*.csv", full.names = T))
  write_csv(data_raw, output_file, na = "")
  message("Dados salvos em ", output_file)
}

if (!interactive()) {
  argv <- commandArgs(TRUE) 
  main(argv)
}
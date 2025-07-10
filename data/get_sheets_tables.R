# header ------------------------------------------------------------------

# This script accesses the tables stored as Google Sheets which contain
# the course data. Each table is read and stored locally as a CSV.

# library -------------------------------------------------------------------

library(googlesheets4)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)

## pre-course survey -----

sheet_pre_course <- "https://docs.google.com/spreadsheets/d/19AbV2P0yybzMbrFiq8_3nPiE-Hj_OUZJLHiWqkCydEk/edit?gid=398618297#gid=398618297"

googlesheets4::read_sheet(ss = sheet_pre_course) |>
  select(-`Timestamp`, -`What is your name?`) |>
  mutate(`What is your name?` = str_to_title(`What is your name?`)) |>
  mutate(`What is your email address?` = str_to_lower(`What is your email address?`)) |>
  mutate(`What is your affiliation?` = str_to_title(`What is your affiliation?`)) |>
  mutate(`What are you hoping to learn from this course?` = str_to_lower(`What are you hoping to learn from this course?`)) |>
  write_csv(here::here("data/tbl-pre-course-survey.csv"))


## openwashdata conference

sheet_openwashdata <- "https://docs.google.com/spreadsheets/d/1dvdHE4GMUmqPhM_1GUdYh6RB5vNbvnWY_XCR37luIHg/edit?gid=0#gid=0"

googlesheets4::read_sheet(ss = sheet_openwashdata) |>
  select(-duration) |>
  mutate(speaker = paste0("[", speaker, "](", speaker_link, "/)")) |>
  mutate(affiliation = paste0("[", affiliation, "](", affiliation_link, "/)")) |>
  mutate(start_time = as.character(start_time)) |>
  mutate(start_time = str_extract(start_time, "\\b\\d{2}:\\d{2}\\b")) |>
  mutate(end_time = as.character(end_time)) |>
  mutate(end_time = str_extract(end_time, "\\b\\d{2}:\\d{2}\\b")) |>
  mutate(time = paste(start_time, end_time, sep = " - ")) |>
  write_csv(here::here("data/tbl-openwashdata-conference-agenda.csv"))

agenda <- readr::read_csv(here::here("data/tbl-openwashdata-conference-agenda.csv"))

agenda_final <- agenda  |>
  select(-start_time, -end_time, -speaker_link, -affiliation_link) |>
  relocate(time) |>
  mutate(speaker = case_when(
    str_detect(speaker, "NA") == TRUE ~ " - ",
    TRUE ~ speaker
  )) |>
  mutate(affiliation = case_when(
    str_detect(affiliation, "NA") == TRUE ~ " - ",
    TRUE ~ affiliation
  ))


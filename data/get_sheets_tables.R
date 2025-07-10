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

pre_course_survey <- googlesheets4::read_sheet(ss = sheet_pre_course)

# Process pre-course survey data
pre_course_survey_clean <- pre_course_survey |>
  select(
    days_signed_up = `Which day(s) are you signing up for?`,
    experience_programming_general = `Which of these best describes your experience with programming in general?`,
    experience_programming_r = `Which of these best describes your experience with programming in R?`,
    experience_programming_python = `Which of these best describes your experience with programming in Python?`,
    other_languages = `Which other programming languages / software do you have experience in?`,
    programming_confidence = `Which of these best describes how easily you could write a program in any language to find the largest number in a list?`,
    experience_git = `Which of these best describes your experience with using Git?`,
    experience_github = `Which of these best describes your experience with using GitHub?`,
    data_storage_format = `In which format do you store the majority of your data?`,
    document_writing_approach = `Which of these best describes how you write narrative documents that include text and analysis?`,
    experience_ides = `Which of these best describes your experience with using Integrated Development Environments (IDEs)?`,
    ides_used = `Which of the following Integrated Development Environments (IDEs) have you used? (Select all that apply)`,
    cli_usage = `Which of these best describes your current usage of the default command-line interface (CLI) on your operating system?
On Mac: The default CLI app is Terminal, and the default shell is Zsh (you may also use Bash or other shells)
On Windows: The default CLI app is Windows Terminal, which can run Command Prompt, PowerShell, and Bash (via Windows Subsystem for Linux)
How would you describe your experience?`,
    llm_usage = `Which best describes your current usage of Language Learning Models (LLMs), for example ChatGPT, for completing tasks (ideation, writing, coding)?`,
    llm_tools_used = `Which of the following Large Language Model (LLM) tools or platforms have you used for research, ideation, writing, coding, or related tasks? (Select all that apply)`,
  ) |>
  filter(days_signed_up != "I won't participate.")

pre_course_survey_clean |>
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


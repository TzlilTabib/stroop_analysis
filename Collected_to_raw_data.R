# -------------------------------------------------------------------------------
# Script name: Pre-processing of the Collected Stroop data
# Description: This script prepares the raw Stroop task data for further analysis
# Author: Tzlil Tabib
# Date: 25.12.2024  
# -------------------------------------------------------------------------------

library(dplyr)

# Combining subjects' files to one data frame
files_names <- dir("stroop_data", full.names = TRUE)

df <- data.frame()

for (file in files_names) {
  df <- rbind(df, read.csv(file))}


# Organizing data
df <- df |>
  mutate(
    task        = ifelse(grepl("word_reading", condition), "word_reading", "ink_naming"),
    congruency  = ifelse(grepl("incong", condition), "incong", "cong"),
    accuracy    = as.numeric(correct_response == participant_response)) |>
  select(subject, task, congruency, block, trial, accuracy, rt) |>
  mutate(
        subject     = as.factor(subject),
        task        = factor(task, levels = c("word_reading", "ink_naming"), ordered = TRUE),
        congruency  = factor(congruency, levels = c("cong", "incong"), ordered = TRUE),
        accuracy    = factor(accuracy, levels = c(0, 1), labels = c("inaccurate", "accurate")),
        block       = as.factor(block),
        trial       = as.numeric(trial),
        rt          = as.numeric(rt))

# Saving raw data
save(df, file = './raw_data.rdata')

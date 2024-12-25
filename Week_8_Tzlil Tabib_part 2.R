# R course for beginners 
# Week 7 part 2
# Assignment by Tzlil Tabib, id 208744755

library(dplyr)

load('./raw_data.rdata')

# Counting subjects
N = n_distinct(df$subject)
print(paste("N =", N , "subjects"))

### PREPARING FILTERED DATA ----------------------------------------------------
# calculation total number of trials per subject
total_trials <- df |>
  group_by(subject) |>
  summarize(total_trials = n())

# Excluding NA trials and (rt < 300 or rt > 3000)
df_filtered <- df |>
  na.omit() |>
  filter(rt > 300 & rt < 3000) 

# calculating remaining number and percentage of trials per subject
remaining_trials <- df_filtered |>
  group_by(subject) |>
  summarize(remaining_trials = n())

trial_summary <- cbind(total_trials, remaining_trials = (remaining_trials$remaining_trials))
trial_summary <- trial_summary |>
  mutate(remaining_trials_per = remaining_trials/total_trials * 100)

trial_summary |>  
  summarize(
  mean_remaining_trials_per = mean(remaining_trials_per),
  sd_remaining_trials_per   = sd(remaining_trials_per))

# Saving filtered data
save(df_filtered, file = './filtered_data.rdata')

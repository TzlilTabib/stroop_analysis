# R course for beginners 
# Week 7 part 3
# Assignment by Tzlil Tabib

library(dplyr)
library(ggplot2)
library(ggdist)
library(lme4)

load('./filtered_data.rdata')

### DESCRIPTIVE STATISTICS -----------------------------------------------------
descriptives <- df_filtered |>
  group_by(congruency, task, accuracy) |>
  summarise(
    mean_rt = mean(rt),
    sd_rt   = sd(rt))

# Descriptive plot for reaction time by congruency and task
ggplot(df_filtered, aes(x = congruency, y = rt, fill = accuracy, color = accuracy)) +
  stat_halfeye(adjust = 0.5, justification = -0.1, .width = 0, alpha = 0.4) +
  geom_boxplot(width = 0.1, alpha = 0.7) +
  geom_jitter(width = 0.1, alpha = 0.4) +
  geom_point(data = descriptives, aes(x = congruency, y = mean_rt), size = 4, color = "black") +
  facet_wrap(~ task) +
  labs(
    title = "Raincloud plot of reaction time by congruency and task",
    x     = "Congruency",
    y     = "Reaction Time (RT)") +
  theme_minimal()

### MIXED EFFECT REGRESSION ----------------------------------------------------
## For predicating reaction time by congruency and type
model <- lmer(rt ~ congruency * task + (1 | subject), data = df_filtered)
summary(model)
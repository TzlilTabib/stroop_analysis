# ------------------------------------------------------------------------------
## Script name: Statistical analyses of the Stroop task 
## Description: This script - 
# (1) Prepares and presents the Stroop task descriptive statistics 
# (2) Performs mixed linear regression analysis 
## Author: Tzlil Tabib
## Date: 25.12.2024  
# ------------------------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(patchwork)
library(lme4)
library(ggdist)

load('./filtered_data.rdata')

### DESCRIPTIVE STATISTICS -----------------------------------------------------
## Reaction time by congruency and task
descriptives_rt <- df_filtered |>
  group_by(congruency, task) |>
  summarise(
    mean_rt = mean(rt),
    sd_rt   = sd(rt))

# Descriptive plot for reaction time by congruency and task
rt_descriptive_figure <- 
  ggplot(descriptives_rt, aes(x = congruency, y = mean_rt, fill = task)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = mean_rt - sd_rt, ymax = mean_rt + sd_rt), width = 0.2, position = position_dodge(0.9)) +
  labs(title = "Mean Reaction Time by Congruency and Task",
       x     = "Congruency",
       y     = "Mean reaction time (ms)") +
  theme_minimal()

## Accuracy by congruency and task
descriptives_accuracy <- df_filtered |>
  group_by(congruency, task) |>
  summarise(
    n_accurate   = sum(accuracy == "accurate"),
    n_inaccurate = sum(accuracy == "inaccurate"))

# Descriptive plot for accuracy by congruency and task
accuracy_descriptive_figure <- 
  ggplot(descriptives_accuracy, aes(x = congruency, fill = task)) +
  geom_bar(stat = "identity", position = "dodge", aes(y = n_accurate)) +
  labs(title = "Number of Accurate Responses by Congruency and Task",
       x     = "Congruency",
       y     = "Count of accurate responses") +
  theme_minimal()

descriptive_figures <- rt_descriptive_figure + accuracy_descriptive_figure
ggsave("descriptive_figures.png", descriptive_figures, width = 15, height = 8)

### MIXED EFFECT REGRESSION ----------------------------------------------------
## For predicating reaction time by congruency and type
model <- lmer(rt ~ congruency * task + (1 | subject), data = df_filtered)
summary(model)

# Presenting the model's predicted rt by the predicting factors and observed results 
df_filtered <- df_filtered |>
  mutate(predicted = predict(model))

mixed_models_figure <- 
  ggplot(df_filtered, aes(x = rt, y = congruency, fill = task)) +
  stat_halfeye(adjust = 0.5, width = 0.6, .width = 0.98, justification = -0.2, point_interval = mean_qi, alpha = 0.5) +
  geom_point(aes(x = predicted), position = position_jitter(width = 0.1, height = 0), color = "black", size = 1.5) +
  labs(title = "Raincloud Plot for Reaction Time by Congruency and Task",
       x     = "Reaction time (ms)",
       y     = "Congruency") +
  theme_minimal()

ggsave("mixed_models_figure.png", mixed_models_figure, width = 15, height = 8)


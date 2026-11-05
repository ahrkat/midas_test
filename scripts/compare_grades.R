#!/usr/bin/env Rscript

# Compare the mean math grade of two groups with a t-test.
#
# Run from the repository root.
#
# On the fictional mock data:
#   Rscript scripts/compare_grades.R
#
# In the vault, pass the path to the real file:
#   Rscript scripts/compare_grades.R /path/to/Grades.xlsx
#
# Results are printed and saved to results/grade_comparison.csv.
# Requires the readxl package.

library(readxl)

# ---- Settings ---------------------------------------------------------------

default_input_file <- "mock_data/mock_Grades.xlsx"
output_file <- "results/grade_comparison.csv"

# CHECK BEFORE RUNNING IN THE VAULT: these must match the labels in the real
# Gender column exactly, including capital letters. The report suppressed the
# real labels, so these are the placeholders used in the mock data.
group_1 <- "Female"
group_2 <- "Male"

# The grade scale confirmed by the researcher.
grade_min <- 1
grade_max <- 6

# ---- Load the data ----------------------------------------------------------

args <- commandArgs(trailingOnly = TRUE)
input_file <- if (length(args) >= 1) args[[1]] else default_input_file

grades <- read_excel(input_file)

# ---- Check the data ---------------------------------------------------------

# These messages name the problem but never print values from the data, so they
# are safe to describe outside the vault.

required_columns <- c("ID", "Gender", "Grade")
if (!all(required_columns %in% names(grades))) {
  stop("The data must contain the columns ID, Gender and Grade.", call. = FALSE)
}

if (anyNA(grades[required_columns])) {
  stop("ID, Gender or Grade has missing values.", call. = FALSE)
}

if (anyDuplicated(grades$ID) > 0) {
  stop("Some IDs appear more than once. The t-test needs one row per student.", call. = FALSE)
}

if (!all(grades$Gender %in% c(group_1, group_2))) {
  stop("Gender has labels other than group_1 and group_2. Check the Settings section.", call. = FALSE)
}

if (!all(c(group_1, group_2) %in% grades$Gender)) {
  stop("One of the two groups has no rows. Check the Settings section.", call. = FALSE)
}

if (!is.numeric(grades$Grade)) {
  stop("Grade is not stored as numbers.", call. = FALSE)
}

if (any(grades$Grade < grade_min | grades$Grade > grade_max)) {
  stop("Some grades are outside the expected scale.", call. = FALSE)
}

# ---- Run the t-test ---------------------------------------------------------

# Setting the factor levels makes the difference group_1 minus group_2.
grades$Gender <- factor(grades$Gender, levels = c(group_1, group_2))

# var.equal = FALSE is Welch's t-test, which does not assume that the two groups
# have the same variance or the same size.
test <- t.test(Grade ~ Gender, data = grades, var.equal = FALSE)

# ---- Collect the results ----------------------------------------------------

group_1_grades <- grades$Grade[grades$Gender == group_1]
group_2_grades <- grades$Grade[grades$Gender == group_2]

results <- data.frame(
  group_1 = group_1,
  group_2 = group_2,
  n_group_1 = length(group_1_grades),
  n_group_2 = length(group_2_grades),
  mean_group_1 = mean(group_1_grades),
  mean_group_2 = mean(group_2_grades),
  sd_group_1 = sd(group_1_grades),
  sd_group_2 = sd(group_2_grades),
  mean_difference = mean(group_1_grades) - mean(group_2_grades),
  ci_95_lower = test$conf.int[1],
  ci_95_upper = test$conf.int[2],
  t_statistic = unname(test$statistic),
  degrees_of_freedom = unname(test$parameter),
  p_value = test$p.value
)

# ---- Print and save ---------------------------------------------------------

print(test)

# results/ is listed in .gitignore, so this file stays out of GitHub.
dir.create(dirname(output_file), showWarnings = FALSE)
write.csv(results, output_file, row.names = FALSE)

cat("Saved results to", output_file, "\n")

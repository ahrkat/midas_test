#!/usr/bin/env Rscript

# Create a FICTIONAL mock version of the grades dataset.
#
# Every value here comes from a random number generator. Nothing is based on
# real observations. The file only copies the structure described in
# PROJECT_BRIEF.md, so analysis code can be developed and tested outside the
# vault.
#
# Run from the repository root:
#   Rscript scripts/make_mock_data.R
#
# Requires the writexl package.

library(writexl)

# ---- Settings ---------------------------------------------------------------

output_file <- "mock_data/mock_Grades.xlsx"

# The brief gives a row count of 100-999. 300 is an arbitrary value in that range.
n_rows <- 300

# ASSUMPTION: the brief suppresses the category labels, so these are placeholders.
gender_labels <- c("Female", "Male")

# The researcher confirmed that grades run from 1 to 6.
# ASSUMPTION: only whole grades are used here. Half grades are not simulated.
grade_min <- 1
grade_max <- 6

# Both groups use the same grade distribution on purpose. Any difference between
# groups in this file is random noise and says nothing about real students.
grade_mean <- 3.5
grade_sd <- 1.1

# A fixed seed means the script produces the same file every time.
set.seed(20261105)

# ---- Build the dataset ------------------------------------------------------

grades <- round(rnorm(n_rows, mean = grade_mean, sd = grade_sd))
grades <- pmin(pmax(grades, grade_min), grade_max)

mock_data <- data.frame(
  # The 900000 range makes these easy to recognise as mock IDs.
  ID = 900000 + seq_len(n_rows),
  Gender = sample(gender_labels, n_rows, replace = TRUE),
  Grade = grades
)

# ---- Save -------------------------------------------------------------------

dir.create(dirname(output_file), showWarnings = FALSE)
write_xlsx(list(Sheet1 = mock_data), output_file)

cat("Wrote", nrow(mock_data), "fictional rows to", output_file, "\n")

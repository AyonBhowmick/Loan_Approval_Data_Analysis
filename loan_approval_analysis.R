# ============================================================
# Loan Approval Dataset: Data Preparation, Cleaning and EDA
# Introduction to Data Science, Group 07
# ============================================================

# ---------- 1. Installing Required Packages ----------
# Installs only the packages that are missing, then loads them all.
# (tidyverse already includes ggplot2 and dplyr.)
required_packages <- c("tidyverse", "caret", "naniar", "VIM", "caTools")

missing_packages <- setdiff(required_packages, rownames(installed.packages()))
if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

invisible(lapply(required_packages, library, character.only = TRUE))


# ---------- 2. Loading the Dataset ----------
# FIX: point to the CSV file itself (not the folder), and strip the leading
# spaces that this Kaggle file has in its text values (" Approved", " Graduate").
df <- read.csv("C:/PROJECT/PROJECT/archive/loan_approval_dataset.csv",
               stringsAsFactors = FALSE, strip.white = TRUE)

names(df) <- trimws(names(df))                       # clean column names too
df[] <- lapply(df, function(x) if (is.character(x)) trimws(x) else x)

head(df)
str(df)
table(df$loan_status)                                # should show Approved and Rejected


# ---------- 3. Missing Value Detection ----------
missing_counts <- sapply(df, function(x) {
  sum(is.na(x) | (is.character(x) & x == ""))
})
missing_counts


# ---------- 4. Handling Missing Values ----------
# Convert empty strings to NA
df$education[df$education == ""] <- NA
df$self_employed[df$self_employed == ""] <- NA
df$loan_status[df$loan_status == ""] <- NA

# Replace categorical missing values
df$education[is.na(df$education)] <- "Unknown"
df$self_employed[is.na(df$self_employed)] <- "Unknown"
df$loan_status[is.na(df$loan_status)] <- "Unknown"

# Replace numeric missing values with mean
df$income_annum[is.na(df$income_annum)] <- mean(df$income_annum, na.rm = TRUE)
df$loan_amount[is.na(df$loan_amount)]   <- mean(df$loan_amount, na.rm = TRUE)
df$cibil_score[is.na(df$cibil_score)]   <- mean(df$cibil_score, na.rm = TRUE)


# ---------- 5. Missing Value Visualization ----------
gg_miss_var(df)
vis_miss(df)


# ---------- 6. Duplicate Detection & Removal ----------
sum(duplicated(df))
df <- df[!duplicated(df), ]


# ---------- 7. Outlier Detection & Removal (IQR) ----------
boxplot(df$income_annum, main = "Outliers in Income")

Q1 <- quantile(df$income_annum, 0.25, na.rm = TRUE)
Q3 <- quantile(df$income_annum, 0.75, na.rm = TRUE)
IQR_val <- IQR(df$income_annum, na.rm = TRUE)

lower_bound <- Q1 - 1.5 * IQR_val
upper_bound <- Q3 + 1.5 * IQR_val

df <- df[df$income_annum >= lower_bound & df$income_annum <= upper_bound, ]


# ---------- 8. Categorical to Numeric ----------
# Works now because the values were trimmed (" Approved" -> "Approved")
df$loan_status   <- ifelse(df$loan_status == "Approved", 1, 0)
df$education     <- as.numeric(as.factor(df$education))       # 1 = Graduate, 2 = Not Graduate
df$self_employed <- as.numeric(as.factor(df$self_employed))   # 1 = No, 2 = Yes

table(df$loan_status)                                # should now show both 0 and 1


# ---------- 9. Numeric to Categorical ----------
df$income_group <- cut(df$income_annum,
                       breaks = c(0, 500000, 1000000, 2000000, Inf),
                       labels = c("Low", "Medium", "High", "Very High"))

df$cibil_group <- cut(df$cibil_score,
                      breaks = c(300, 600, 700, 800, 900),
                      labels = c("Poor", "Average", "Good", "Excellent"),
                      include.lowest = TRUE)


# ---------- 10. Normalization ----------
df$income_norm      <- as.numeric(scale(df$income_annum))
df$loan_amount_norm <- as.numeric(scale(df$loan_amount))


# ---------- 11. Train-Test Split (FIRST) ----------
# FIX: split before balancing, so duplicated rows never appear in both sets.
df$loan_status <- as.factor(df$loan_status)

set.seed(123)
split <- sample.split(df$loan_status, SplitRatio = 0.7)

train_data <- subset(df, split == TRUE)
test_data  <- subset(df, split == FALSE)


# ---------- 12. Balancing (training set only) ----------
table(train_data$loan_status)

set.seed(123)
max_n <- max(table(train_data$loan_status))

train_balanced <- train_data %>%
  group_by(loan_status) %>%
  slice_sample(n = max_n, replace = TRUE) %>%
  ungroup()

table(train_balanced$loan_status)                    # equal counts now
table(test_data$loan_status)                         # test set keeps the real distribution


# ---------- 13. Data Filtering ----------
high_income          <- df %>% filter(income_annum > 1000000)
approved_loans       <- df %>% filter(loan_status == 1)
self_employed_people <- df %>% filter(self_employed == 2)   # 2 = "Yes" after encoding

nrow(high_income); nrow(approved_loans); nrow(self_employed_people)


# ---------- 14. Invalid Data Detection ----------
summary(df)

invalid_income <- df %>% filter(income_annum <= 0)
invalid_loan   <- df %>% filter(loan_amount <= 0)

invalid_income
invalid_loan


# ---------- 15. Descriptive Statistics ----------
summary(df$income_annum)

# Mean income, loan amount and CIBIL score by loan status
df %>%
  group_by(loan_status) %>%
  summarise(
    Count       = n(),
    Mean_Income = mean(income_annum, na.rm = TRUE),
    Mean_Loan   = mean(loan_amount, na.rm = TRUE),
    Mean_CIBIL  = mean(cibil_score, na.rm = TRUE)
  )

# Variation comparison
df %>%
  group_by(loan_status) %>%
  summarise(
    SD_Income = sd(income_annum, na.rm = TRUE),
    SD_Loan   = sd(loan_amount, na.rm = TRUE),
    SD_CIBIL  = sd(cibil_score, na.rm = TRUE)
  )


# ---------- 16. Exploratory Data Analysis ----------
# Readable labels for the plots
df$status_label <- factor(df$loan_status, levels = c(0, 1), labels = c("Rejected", "Approved"))

# 16.1 Loan status count
ggplot(df, aes(x = status_label, fill = status_label)) +
  geom_bar() +
  labs(title = "Loan Approval Count", x = "Loan Status", y = "Count", fill = "Loan Status")

# 16.2 Income distribution
ggplot(df, aes(income_annum)) +
  geom_histogram(fill = "purple", bins = 30) +
  labs(title = "Income Distribution", x = "Annual Income", y = "Count")

# 16.3 Income vs loan status
ggplot(df, aes(x = status_label, y = income_annum, fill = status_label)) +
  geom_boxplot() +
  labs(title = "Income vs Loan Status", x = "Loan Status", y = "Annual Income", fill = "Loan Status")

# 16.4 CIBIL score vs loan status
ggplot(df, aes(x = status_label, y = cibil_score, fill = status_label)) +
  geom_boxplot() +
  labs(title = "CIBIL Score vs Loan Status", x = "Loan Status", y = "CIBIL Score", fill = "Loan Status")

# 16.5 Dot plot of income
ggplot(df, aes(x = income_annum)) +
  geom_dotplot(binwidth = 50000, fill = "blue") +
  labs(title = "Dot Plot of Income", x = "Annual Income")

# 16.6 Density plot of income
ggplot(df, aes(x = income_annum)) +
  geom_density(fill = "green", alpha = 0.5) +
  labs(title = "Density Plot of Income", x = "Annual Income", y = "Density")

# 16.7 Income vs loan amount
ggplot(df, aes(x = income_annum, y = loan_amount)) +
  geom_point(color = "red", alpha = 0.5) +
  labs(title = "Income vs Loan Amount", x = "Annual Income", y = "Loan Amount")

# 16.8 Education vs loan status
ggplot(df, aes(x = factor(education, levels = c(1, 2), labels = c("Graduate", "Not Graduate")),
               fill = status_label)) +
  geom_bar(position = "dodge") +
  labs(title = "Education vs Loan Status", x = "Education", y = "Count", fill = "Loan Status")

# 16.9 Loan approval distribution (pie)
loan_counts <- table(df$status_label)
pie(loan_counts, col = c("tomato", "seagreen"),
    labels = paste0(names(loan_counts), " (", loan_counts, ")"),
    main = "Loan Approval Distribution")

# 16.10 Income distribution by loan status
ggplot(df, aes(x = status_label, y = income_annum, fill = status_label)) +
  geom_violin() +
  labs(title = "Income Distribution by Loan Status", x = "Loan Status", y = "Annual Income", fill = "Loan Status")

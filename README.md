<h1 align="center">Loan Approval Data Analysis</h1>
<p align="center"><b>Data preparation, cleaning, and exploratory data analysis of a loan approval dataset in R</b></p>

<p align="center">
  <img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" alt="R"/>
  <img src="https://img.shields.io/badge/tidyverse-1A162D?style=for-the-badge&logo=tidyverse&logoColor=white" alt="tidyverse"/>
  <img src="https://img.shields.io/badge/ggplot2-E15759?style=for-the-badge" alt="ggplot2"/>
  <img src="https://img.shields.io/badge/RStudio-75AADB?style=for-the-badge&logo=rstudioide&logoColor=white" alt="RStudio"/>
  <img src="https://img.shields.io/badge/Dataset-Kaggle-20BEFF?style=for-the-badge&logo=kaggle&logoColor=white" alt="Kaggle"/>
</p>

---

## 📌 Overview
Banks decide on loan applications using applicant data such as income, credit score, and assets. Raw data like this is often messy, with missing values, duplicates, outliers, and imbalanced classes, which leads to unreliable analysis.

This project builds a complete **data preparation and exploratory data analysis (EDA) pipeline in R** that turns the raw loan dataset into clean, model-ready data and uses statistics and visualizations to find the factors linked to loan approval.

> Course project for **Introduction to Data Science**, American International University-Bangladesh (AIUB).

---

## 🔄 Workflow
<p align="center"><img src="images/workflow.png" alt="Workflow" width="100%"/></p>

---

## 📊 Dataset
**[Loan Approval Prediction Dataset](https://www.kaggle.com/datasets/architsharma01/loan-approval-prediction-dataset)** (Kaggle): **4,269 records**, **13 columns**.

| Column | Description |
|---|---|
| `loan_id` | Unique application ID |
| `no_of_dependents` | Number of dependents |
| `education` | Graduate / Not Graduate |
| `self_employed` | Yes / No |
| `income_annum` | Annual income |
| `loan_amount` | Requested loan amount |
| `loan_term` | Loan duration (years) |
| `cibil_score` | Credit score (300 to 900) |
| `residential_assets_value`, `commercial_assets_value`, `luxury_assets_value`, `bank_asset_value` | Asset values |
| `loan_status` | **Target**: Approved / Rejected |

---

## 🧹 Data Preparation Steps
| Problem | Solution |
|---|---|
| Missing values | Empty strings to NA; categorical NA set to "Unknown"; numeric NA replaced with mean |
| Extra spaces in text values | Trimmed with `strip.white` and `trimws()` |
| Duplicate records | Detected and removed with `duplicated()` |
| Outliers | IQR rule on annual income |
| Categorical features | Binary and factor encoding |
| Continuous features | Grouped into income and CIBIL categories |
| Different scales | Z-score standardization with `scale()` |
| Class imbalance | 70/30 train-test split first, then upsampling on the **training set only** (no data leakage) |
| Invalid values | Checked for zero or negative income and loan amount |

---

## 📈 Key Visualizations
| Loan Approval Count | CIBIL Score vs Loan Status |
|---|---|
| <img src="images/loan_approval_count.png" width="100%"/> | <img src="images/cibil_vs_loan_status.png" width="100%"/> |

| Income vs Loan Status | Education vs Loan Status |
|---|---|
| <img src="images/income_vs_loan_status.png" width="100%"/> | <img src="images/education_vs_loan_status.png" width="100%"/> |

| Income vs Loan Amount | Income Distribution |
|---|---|
| <img src="images/income_vs_loan_amount.png" width="100%"/> | <img src="images/income_distribution.png" width="100%"/> |

## 🔍 Key Findings
- **About 62% of applications are approved** and 38% rejected, so the target is moderately imbalanced.
- **CIBIL score is the strongest factor:** the median score is about **710 for approved** applicants vs about **430 for rejected** ones.
- **Income barely differs** between approved and rejected applicants, so income alone does not decide approval.
- **Education has little effect:** graduates and non-graduates have very similar approval counts.
- **Loan amount rises with income**, showing a strong positive relationship.

---|---|
| <img src="images/income_distribution.png" width="100%"/> | <img src="images/income_vs_loan_amount.png" width="100%"/> |

| Income Density | Outlier Check (Boxplot) |
|---|---|
| <img src="images/income_density.png" width="100%"/> | <img src="images/income_outliers_boxplot.png" width="100%"/> |

---

## 📁 Project Structure
```
Loan_Approval_Data_Analysis/
├── loan_approval_analysis.R      # full R script
├── report/
│   ├── Loan_Approval_EDA_Report_Group7.pdf
│   └── Loan_Approval_EDA_Report_Group7.docx
├── images/                       # figures used in this README
└── README.md
```

---

## ▶️ How to Run
1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/architsharma01/loan-approval-prediction-dataset).
2. Open `loan_approval_analysis.R` in RStudio.
3. Update the file path in `read.csv()` to where you saved `loan_approval_dataset.csv`.
4. Install the packages once:
   ```r
   install.packages(c("tidyverse", "ggplot2", "caret", "dplyr", "naniar", "VIM", "caTools"))
   ```
5. Run the script from top to bottom.

---

## 📄 Report
The full project report covers every step with code, outputs, and figures.

<p>
  <a href="report/Loan_Approval_EDA_Report_Group7.pdf"><img src="https://img.shields.io/badge/View%20Report-PDF-D32F2F?style=for-the-badge&logo=adobeacrobatreader&logoColor=white" alt="View PDF Report"/></a>
  <a href="report/Loan_Approval_EDA_Report_Group7.docx"><img src="https://img.shields.io/badge/Download%20Report-Word-2B579A?style=for-the-badge&logo=microsoftword&logoColor=white" alt="Download Word Report"/></a>
</p>

**Contents:** Introduction, Dataset Description, Data Issues, Data Cleaning & Preparation (15 steps), Descriptive Statistics, Exploratory Data Analysis, Conclusion, and Future Work.

---

## 👥 Team
| Name | Contribution |
|---|---|
| Ayon Kumar Bhowmick Ovi | 35% |
| Sheikh MD. Atik Shahoriyer Badhon | 25% |
| Dipu Roy | 20% |
| Sumiya Haider Risa | 20% |

**Supervisor:** Kamrun Naher Koli

---

<p align="center">⭐ If you found this project useful, consider giving it a star!</p>

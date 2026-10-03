# Power BI Dashboard — Step-by-Step

## STEP 1 — Open Power BI Desktop
Open Power BI Desktop.

## STEP 2 — Import the CSV
Home -> Get Data -> Text/CSV
Select:
data/customer_churn.csv

Click Load.

The table should appear as:
customer_churn

## STEP 3 — Check columns
You should have:
CustomerID
Age
Gender
Region
Plan
TenureMonths
MonthlyCharges
TotalSpend
PaymentMethod
SupportInteractions
Churn

Set:
- Age -> Whole number
- TenureMonths -> Whole number
- SupportInteractions -> Whole number
- MonthlyCharges -> Decimal number
- TotalSpend -> Decimal number
- Churn -> Text

## STEP 4 — Create DAX measures
Go to:
Modeling -> New measure

Create the measures from:
powerbi/dax_measures.txt

## STEP 5 — Page 1: Executive Dashboard
Rename page:
Executive Dashboard

Create 6 Card visuals across the top:
1. Total Customers
2. Churned Customers
3. Churn Rate %
4. Retention Rate %
5. Revenue at Risk
6. Average Monthly Charge

Recommended visuals below:
- Clustered column: Churn Rate % by Plan
- Bar chart: Churn Rate % by Region
- Column chart: Churn Rate % by Tenure Band
- Donut: Churned vs Retained
- Bar chart: Churn Rate % by Payment Method

## STEP 6 — Add slicers
Add slicers for:
- Region
- Plan
- Gender
- PaymentMethod

## STEP 7 — Create Tenure Band calculated column
Modeling -> New column:

Tenure Band =
SWITCH(
    TRUE(),
    customer_churn[TenureMonths] <= 12, "0-12 Months",
    customer_churn[TenureMonths] <= 24, "13-24 Months",
    customer_churn[TenureMonths] <= 36, "25-36 Months",
    customer_churn[TenureMonths] <= 48, "37-48 Months",
    "49+ Months"
)

Use Tenure Band on the x-axis and Churn Rate % as values.

## STEP 8 — Page 2: Churn Analysis
Create a second page:
Churn Analysis

Add:
- Churn Rate by Plan
- Churn Rate by Region
- Churn Rate by Payment Method
- Churn Rate by Tenure Band
- Support Interactions vs Churn Rate
- Average Monthly Charges by Churn Status

## STEP 9 — Page 3: Customer Risk
Create:
Customer Risk

Add a table with:
CustomerID
Region
Plan
TenureMonths
MonthlyCharges
TotalSpend
SupportInteractions
Churn

Filter Churn = Yes.

Sort TotalSpend descending.

This shows high-value churned customers.

## STEP 10 — Formatting
Use a clean professional theme.
Keep KPI cards at the top.
Use consistent titles.
Turn on data labels where useful.
Format Churn Rate and Retention Rate as percentages.
Format Revenue at Risk as currency.

## STEP 11 — Final dashboard layout

EXECUTIVE DASHBOARD

[Total Customers] [Churned] [Churn %] [Retention %] [Revenue at Risk] [Avg Charge]

[Churn by Plan]       [Churn by Region]

[Churn by Tenure]     [Churn by Payment Method]

[Slicers: Region | Plan | Gender | Payment Method]

## STEP 12 — Optional MySQL workflow
If you want to demonstrate SQL in the project:
1. Create database churn_analytics in MySQL Workbench.
2. Create the customer_churn table using sql/churn_analysis.sql.
3. Import customer_churn.csv.
4. Run the analysis queries.
5. Use the results to validate the Power BI KPIs.

For a portfolio project, the simplest Power BI route is importing the cleaned CSV directly.

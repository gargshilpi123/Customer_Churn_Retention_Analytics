import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(r"C:\Users\SHILPI GARG\Downloads\Customer_Churn_Retention_Analytics\Customer_Churn_Retention_Analytics\data\customer_churn.csv")
print("\nShape:", df.shape)
print("\nMissing values:\n", df.isna().sum())
print("\nData types:\n", df.dtypes)

# Cleaning
df["Age"] = df["Age"].fillna(df["Age"].median())
df["MonthlyCharges"] = df["MonthlyCharges"].fillna(df["MonthlyCharges"].median())
df["PaymentMethod"] = df["PaymentMethod"].fillna(df["PaymentMethod"].mode()[0])

# KPIs
churn_rate = (df["Churn"].eq("Yes").mean()) * 100
retention_rate = (df["Churn"].eq("No").mean()) * 100
revenue_at_risk = df.loc[df["Churn"].eq("Yes"), "TotalSpend"].sum()

print(f"\nChurn rate: {churn_rate:.2f}%")
print(f"Retention rate: {retention_rate:.2f}%")
print(f"Revenue at risk: {revenue_at_risk:,.2f}")

# EDA
print("\nChurn by plan:")
print(pd.crosstab(df["Plan"], df["Churn"], normalize="index").round(3))

print("\nChurn by region:")
print(pd.crosstab(df["Region"], df["Churn"], normalize="index").round(3))

print("\nChurn by payment method:")
print(pd.crosstab(df["PaymentMethod"], df["Churn"], normalize="index").round(3))

# Correlation for numeric variables
numeric = df[["Age","TenureMonths","MonthlyCharges","TotalSpend","SupportInteractions"]].copy()
print("\nCorrelation matrix:")
print(numeric.corr().round(2))

# Charts
df.groupby("Plan")["Churn"].apply(lambda x: (x=="Yes").mean()*100).plot(kind="bar")
plt.ylabel("Churn Rate (%)")
plt.title("Churn Rate by Plan")
plt.tight_layout()
plt.savefig("churn_by_plan.png")
plt.show()


## Screenshots

![App Screenshot](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/Screenshot_1.png)
![App Screenshot](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/Screenshot_4.png)
![App Screenshot](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/Screenshot_5.png)

## 🔗 Links
  

  
  [![Python: Visualizations for Correlation and Data Cleaning Code](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/Code%20and%20Visualizations%20for%20Data%20Cleaning%20%2B%20Correlation.ipynb)](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/Code%20and%20Visualizations%20for%20Data%20Cleaning%20%2B%20Correlation.ipynb/)
  
   [![Tableau: Visualizations for Marketing Consumer Profile](https://public.tableau.com/app/profile/haoming.chen1867/viz/HealthcareInsuranceConsumerMarketing2/Dashboard1)](https://public.tableau.com/app/profile/haoming.chen1867/viz/HealthcareInsuranceConsumerMarketing2/Dashboard1)

  [![SQL: Marketing Consumer Profile Analysis](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/Marketing%20Consumer%20Profile%20Analysis%20in%20SQL.sql)](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/Marketing%20Consumer%20Profile%20Analysis%20in%20SQL.sql/)

  [![Raw Dataset used for this project](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/expenses.csv)](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Healthcare%20Insurance%20Consumer%20Marketing/expenses.csv)

  [![Other Project](https://github.com/HaomingChen1998/Portfolio-Project)](https://github.com/HaomingChen1998/Portfolio-Project/)
  
  [![Linkedin Page](https://www.linkedin.com/in/haomingchen1998/)](https://www.linkedin.com/in/haomingchen1998/)

# Overview
Source from https://www.kaggle.com/datasets/fibonamew/insurance-data
- This dataset contains information about 7 features and the actual medical charges incurred by over 1300 customers within ACME Insurance Inc. The age column from this dataset is from 18-64, so assuming no Medicare plans.
- The purpose of this project is to visualize the most profitable consumer profiles for ACME Insurance Inc and increase the effectiveness and efficiency of advertising campaigns.
- In my case, target consumer is defined as the group of consumer that generate maximum revenue (highest charge)
- The metric measured is the average charge per customer, higher charge indicate more revenue. Using this metric is to account for the uneven number of total customers when I compare customer profiles.
- Adult is defined as age between 18 to 30. Middle age is defined as age between 31-64. No data on anyone above 64, so no senior age group.

# Actionable Insights
- Discovered the 2 most correlated consumer features in respect to the company's revenue are smoking status with 79% correlation and age with 30% correlation.
- Concluded smoker group generated 280% higher revenue than non-smoker group and middle age group generated 62% higher revenue than adult age group. The company should shift its marketing focus toward middle-aged smoker to maximize revenue.

# Procedure for this project
1. Cleaned the data using Python. Although the data is already cleaned, but I still show how to code if I need to clean this data.
2. Visualized the most correlated consumer features to revenue using Python.
3. Found out actionable insights using SQL.
4. Visualized the insights in Tableau.

# Lesson Learned from this Project
- Only use one matrix so it doesn't confuse people. Ex: if you use percentage, then don't use ratio.
- Use charge per person instead of total charge, so the sample size won't be a problem when you are comparing two things.
- How to find the most correlated consumer features using Python.
- Use pie chart when you are only comparing two things, bar chart will take more space and look empty.
- I can use certain non-numeric consumer features for correlation as well.

# Lesson Learned from people I present my project to
- Use one matrix/normalization, it means comparing apples to apples.
- Segmentation/grouping (age group, sex).
- Add a column with unique identifier if this dataset doesn't already have one.
- Correlation does not necessarily indicate causation.


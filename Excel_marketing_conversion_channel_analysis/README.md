![Screenshot_1](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Excel_marketing_conversion_channel_analysis/Dashboard%20Preview.png)

## 🔗 Links
  [![Excel File that contains dashboard visulizations, analysis, raw data, cleaned data](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Excel_marketing_conversion_channel_analysis/marketing_conversion_channel_analysis_dashboard.xlsx)

  [![Other Project](https://github.com/HaomingChen1998/Portfolio-Project)](https://github.com/HaomingChen1998/Portfolio-Project/)
  
  [![Linkedin Page](https://www.linkedin.com/in/haomingchen1998/)](https://www.linkedin.com/in/haomingchen1998/)


# Overview: Purpose of this Project and the dataset used
- Source from: https://www.kaggle.com/datasets/rodsaldanha/arketing-campaign?select=marketing_campaign.xlsx
- About Dataset: this dataset contains information about a marketing campaign including different consumer profiles, offer acceptance status, and different marketing channels.<br />
AcceptedCmp1 - 1 if customer accepted the offer in the 1st campaign, 0 otherwise<br />
AcceptedCmp2 - 1 if customer accepted the offer in the 2nd campaign, 0 otherwise<br />
AcceptedCmp3 - 1 if customer accepted the offer in the 3rd campaign, 0 otherwise<br />
AcceptedCmp4 - 1 if customer accepted the offer in the 4th campaign, 0 otherwise<br />
AcceptedCmp5 - 1 if customer accepted the offer in the 5th campaign, 0 otherwise<br />
Response (target) - 1 if customer accepted the offer in the last campaign, 0 otherwise<br />
Complain - 1 if customer complained in the last 2 years<br />
DtCustomer - date of customer’s enrolment with the company<br />
Education - customer’s level of education<br />
Marital - customer’s marital status<br />
Kidhome - number of small children in customer’s household<br />
Teenhome - number of teenagers in customer’s household<br />
Income - customer’s yearly household income<br />
MntFishProducts - amount spent on fish products in the last 2 years<br />
MntMeatProducts - amount spent on meat products in the last 2 years<br />
MntFruits - amount spent on fruits products in the last 2 years<br />
MntSweetProducts - amount spent on sweet products in the last 2 years<br />
MntWines - amount spent on wine products in the last 2 years<br />
MntGoldProds - amount spent on gold products in the last 2 years<br />
NumDealsPurchases - number of purchases made with discount<br />
NumCatalogPurchases - number of purchases made using catalogue<br />
NumStorePurchases - number of purchases made directly in stores<br />
NumWebPurchases - number of purchases made through company’s web site<br />
NumWebVisitsMonth - number of visits to company’s web site in the last month<br />
Recency - number of days since the last purchase<br />



## Actionable Insights


Campaign 3 had the highest percentage of purchases in both the Store and Deal channel. This suggests that customers were more inclined to make purchases through these channels during Campaign 3 compared to the other campaigns, indicating the effectiveness of these channels in driving customer engagement and potential conversions. Therefore, to recreate the success of Campaign 3, focusing on both the Store and Web channels would be advisable.



## Procedure

                                                     Data Cleaning  
  **Excel:** 
1.	Replaced 54080 corrupted punctuation (â€) with the correct punctuation (‘). 
Ex: Masterâ€™s to Master’s.
2.	Exported as a workbook and imported into Microsoft SQL Server.
      
        
         


   
**Microsoft SQL Server:**  
       SQL coding link is at the top of this page
1.	Removed duplicates using row_number/window function.
2.	Replaced NULL value with 0 for YearsCode column because there should be 0 to indicate a candidate without any experience in coding, but it only has NA, 1, 2, etc. Therefore, I assume NA means 0 years of experience, this will make SQL coding and visualization in Tableau easier.
3.	I couldn’t populate any columns with NULL values because there wasn’t a reference point.
4.	Created two new tables: a Company_Table and a Background_Table, from the cleaned dataset. Response ID is kept for each table, so join function could be used after.
-	Company_Table has columns such as Response ID as the primary key, organization size, RemoteWork (working model), total compensation, compensation frequency.
-	Background_Table has columns such as Response ID as the primary key, education level, country, DevType (current job name), employment status, database have worked with, age, gender, sex, etc.







                                                    Data Exploration
**Microsoft SQL Server:**      
        SQL coding link is at the top of this page  
    Things I discovered were:
1.	Most popular/common Platform, Language, and Database skill usage counts for an employed person as a data analyst worldwide.
2.	Analyst employment rate per country with less than 2 year of coding experience (any coding education also counts toward coding experience).
3.	Analyst employment rate per education level.
4.	Analyst employment rate per working model (remote/hybrid/in-person) with less than 2 year of coding experience.
5.	Analyst global employment rate with less than 2 year of coding experience.    
  
    
                                                   Tableau Visualization 
Visualization link can be found at the the top of this page.













                                                    What I Have Learned
**Advice received from multiple Senior Data Analysts on my project while networking on Linkedin:**
1.	Perform data cleaning such as removing duplicates and populate null values first then break up the data set.
2.	Minimize the use of CTE or subquery.
3.  Use intense color to hightlight what you are trying to point out in Tableau, use lighter color for information that aren't important.
4. Do not bombard people with information, only hightlight the main focus.

**Lesson learned from doing this project from my own mistakes:**

1.	Before you remove the duplicate, use select statement to see what you’re deleting, once you confirmed that everything looks correct, then change it to delete statement.
2.	Do not start query before you fully understand the dataset you are working with.
3.	Although I can remove duplicates much easier in Excel, but when the dataset becomes too large, Excel might crash while removing the duplicates, so SQL is better in terms of handling larger dataset.
4.	When I want to see the employment rate per country, I need to exclude countries where the sample size is small. Because the results won’t be significant, and they can skew the overall trend.
5.	Before importing to Tableau, make sure to replace all the NULL values with 0 because it could mistake that with a string.



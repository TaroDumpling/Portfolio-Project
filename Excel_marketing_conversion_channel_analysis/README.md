![Screenshot_1](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Excel_marketing_conversion_channel_analysis/Dashboard%20Preview.png)

## 🔗 Links
  [!Excel File that contains dashboard visulizations, analysis, raw data, cleaned data](https://github.com/HaomingChen1998/Portfolio-Project/blob/main/Excel_marketing_conversion_channel_analysis/marketing_conversion_channel_analysis_dashboard.xlsx)

  [![Other Project](https://github.com/HaomingChen1998/Portfolio-Project)](https://github.com/HaomingChen1998/Portfolio-Project/)
  
  [![Linkedin Page](https://www.linkedin.com/in/haomingchen1998/)](https://www.linkedin.com/in/haomingchen1998/)


# Overview: Purpose of this Project and the dataset used
- The purpose is to identify the most successful marketing campaign and find out what contribute to the success of that campaign, so the same success can be re-created in the future.
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
1.	Removed duplicates.
2.	No Null Values found.
3.	Standardize capitalization
4.	Remove unnecessary blank space.<br />
      



                                                    Data Exploration
1. Calculated conversion rate in percentage by each marketing campaign (customer who accepted the offer after the campaign/ total customers from that campaign)*100
2. Calculated percentage of total purchases for each channel (customer who accepted the offer after the campaign from a specific channel / total customers from that campaign from a specific channel)*100
  
    
                                                   Tableau Visualization 
1. Visualized the highest conversion rate with darker color to highlight key insights, and used lighter color to downplay less important details, such as unsuccessful campaigns.



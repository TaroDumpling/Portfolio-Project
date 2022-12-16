#!/usr/bin/env python
# coding: utf-8

# In[2]:


# import libraries

from bs4 import BeautifulSoup
import requests
import time
import datetime


# In[3]:


# Get your User-Agent with this link to make the website thinking you are a real person visiting the website: httpbin.org/get
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

source = requests.get('https://gasprices.aaa.com/?state=US', headers=headers)

soup = BeautifulSoup(source.text,'html.parser')

soup1= BeautifulSoup(soup.prettify(), 'html.parser')

all_gas_price = soup1.find('div', class_='tblwrap').tbody.tr.text.split()[2:]


# In[4]:


regular = all_gas_price[:1]

mid_grade = all_gas_price[1:2]

premium = all_gas_price[2:3]

diesel = all_gas_price[3:4]

e85 = all_gas_price[4:5]


# In[5]:


# Create a Timestamp for when data was collected

import datetime

today = datetime.date.today()

print(today)


# In[6]:


# Create CSV and write headers and data into the file

import csv 

header = ['regular', 'mid_grade', 'premium', 'diesel', 'e85', 'date']
data = [regular, mid_grade, premium, diesel, e85, today]


with open('Gas_Price_Web_Scraper_Dataset.csv', 'w', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


# In[7]:


import pandas as pd

df = pd.read_csv(r'C:\Users\cody\Gas_Price_Web_Scraper_Dataset.csv')

print(df)


# In[10]:


#Appending data to the csv

with open('Gas_Price_Web_Scraper_Dataset.csv', 'a+', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(data)


# In[8]:


#Combine all of the above code into one function

def check_price():
    
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

    source = requests.get('https://gasprices.aaa.com/?state=US', headers=headers)

    soup = BeautifulSoup(source.text,'html.parser')

    soup1= BeautifulSoup(soup.prettify(), 'html.parser')

    all_gas_price = soup1.find('div', class_='tblwrap').tbody.tr.text.split()[2:]
    
    regular = all_gas_price[:1]

    mid_grade = all_gas_price[1:2]

    premium = all_gas_price[2:3]

    diesel = all_gas_price[3:4]

    e85 = all_gas_price[4:5]
    
    import datetime

    today = datetime.date.today()
    
    import csv 

    header = ['regular', 'mid_grade', 'premium', 'diesel', 'e85', 'date']
    data = [regular, mid_grade, premium, diesel, e85, today]


    with open('Gas_Price_Web_Scraper_Dataset.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)


# In[ ]:


# Runs check_price after 24 hours and inputs data into the CSV

while(True):
    check_price()
    time.sleep(86400)


# In[ ]:





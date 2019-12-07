# Importing packages 
import numpy as np
import pandas as pd

# Import Data
my_client = pd.read_csv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/CLIENT_191102.tsv", sep = '\t')[['Client ID', 'Client Age at Entry', 'Client Age at Exit', 'Client Gender', 'Client Primary Race', 'Client Ethnicity']]
my_disability_entry = pd.read_csv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/DISABILITY_ENTRY_191102.tsv", sep = '\t')[['Client ID','Disability Determination (Entry)', 'Disability Type (Entry)']]
my_disability_exit = pd.read_csv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/DISABILITY_EXIT_191102.tsv", sep = '\t')[['Client ID','Disability Determination (Exit)', 'Disability Type (Exit)']]

# Rename and merge all datasets
my_disability_entry.rename(columns = {'Disability Type (Entry)':'Disability Type'}, inplace = True)
my_disability_exit.rename(columns = {'Disability Type (Exit)':'Disability Type'}, inplace = True)

# Merge data by client ID
my_disability = pd.merge(my_disability_entry, my_disability_exit, on=['Disability Type','Client ID'], how = 'right')
my_disability.drop_duplicates(keep=False,inplace=True)

# Flag those patients who got a disability while at the UMD
my_disability["GotDisability"] = 0
my_disability.loc[(my_disability['Disability Determination (Entry)'] == 'No (HUD)') &
                            (my_disability['Disability Determination (Exit)'] == 'Yes (HUD)'), 'GotDisability'] = 1
                            
                            # Merge and remove the (HUD)
my_patients = pd.merge(my_disability, my_client, on = 'Client ID', how = 'left')
my_patients.replace(regex=True,inplace=True,to_replace="(HUD)",value=r'')
my_patients.replace(regex=True,inplace=True,to_replace=r"\(.*\)",value=r'')

# Indicator for age group
my_patients.loc[(my_patients['Client Age at Exit'] < 25), 'Age_Cat'] = '<25'
my_patients.loc[(my_patients['Client Age at Exit'] < 35) & 
                (my_patients['Client Age at Exit'] >= 25), 'Age_Cat'] = '25-34'
my_patients.loc[(my_patients['Client Age at Exit'] < 45) & 
                (my_patients['Client Age at Exit'] >= 35), 'Age_Cat'] = '35-44'
my_patients.loc[(my_patients['Client Age at Exit'] < 55) & 
                (my_patients['Client Age at Exit'] >= 45), 'Age_Cat'] = '45-54'
my_patients.loc[(my_patients['Client Age at Exit'] < 65) & 
                (my_patients['Client Age at Exit'] >= 55), 'Age_Cat'] = '55-64'
my_patients.loc[(my_patients['Client Age at Exit'] >= 65), 'Age_Cat'] = '>64'

# Grouping Unkown Races
my_patients['Client Primary Race'].replace(regex=True,inplace=True,to_replace="Client refused",value=r'Unknown')
my_patients['Client Primary Race'].replace(regex=True,inplace=True,to_replace="Data not collected",value=r'Unknown')
my_patients['Client Primary Race'].replace(regex=True,inplace=True,to_replace="Asian",value=r'Other')
my_patients['Client Primary Race'].replace(regex=True,inplace=True,to_replace="Native Hawaiian or Other Pacific Islander",value=r'Other')

# Rename and create dummy variables
my_patients.rename(columns = {'Client Primary Race':'Race'}, inplace = True)
my_patients.rename(columns = {'Client Gender':'Gender'}, inplace = True)

#Save data to create plots

# Demographics graph
my_patients[my_patients.GotDisability == 1].to_csv('patients_data_graph.csv')

# Disability Tabulation
mysummary = my_patients[my_patients.GotDisability == 1].groupby(['Gender', 'Disability Type']).count()[['Client ID']]
mysummary.rename(columns = {'Client ID':'N'}, inplace = True)
mysummary.to_csv('counts.csv')

# Logistic Regression Data
my_patients.to_csv('logistic_data.csv')

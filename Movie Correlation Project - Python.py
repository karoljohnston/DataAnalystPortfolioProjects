#!/usr/bin/env python
# coding: utf-8

# In[8]:


# Import Libraries

import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize']=(12,8) # Adjusts the configuration of the plots we will create


# Read in the data
df = pd.read_csv(r'C:\Users\giane\Downloads\archive\movies.csv')


# In[6]:


#Let's look at the data

df.head()


# In[18]:


# Checking if there's any missing data

for col in df.columns:
    pct_missing=np.mean(df[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))


# In[16]:


# Data type for columns

print(df.dtypes)


# In[19]:


#Are there any outliers?

df.boxplot(column=['gross'])


# In[20]:


df.drop_duplicates()


# In[60]:


#Changing data types of column

df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')


# In[22]:


df


# In[28]:


# Creating a month column using released column
df['monthcorrect'] = df['released'].astype(str).str[:4]
df


# In[34]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[33]:


pd.set_option('display.max_rows', None)


# In[35]:


# Drop any duplicates

df['company'].drop_duplicates().sort_values(ascending=False)


# In[36]:


# Deleting any dupliates in the data frame
#df.drop_duplicates()


# In[40]:


#Budget high correlation
# Scallter plot with budget vs gross





plt.scatter(x=df['budget'], y=df['gross'])


plt.title('Budget vs Gross Earnings')
plt.xlabel('Gross Earnings')
plt.ylabel('Budget for film')
plt.show()


# In[39]:


df.head()


# In[45]:


# Plot the budget vs gross using seaborn

sns.regplot(x='budget',y='gross', data=df, scatter_kws={"color":"yellow"}, line_kws={"color":"blue"})


# In[46]:


# Looking at correlations

df.corr()


# In[50]:


correlation_matrix = df.corr(method='pearson')
sns.heatmap(correlation_matrix, annot=True)
plt.title('Correlation Matrix for numeric features')

plt.xlabel('Movie features')
plt.ylabel('Movie features')
plt.show()


# In[51]:


#Looks at company

df.head()


# In[58]:


df_numerize = df

for col_name in df_numerize.columns:
    if(df_numerize[col_name].dtype=='object'):
        df_numerize[col_name] = df_numerize[col_name].astype('category')
        df_numerize[col_name] = df_numerize[col_name].cat.codes
        
df_numerize


# In[55]:


df.head()


# In[56]:


df


# In[61]:


correlation_matrix = df_numerize.corr(method='pearson')
sns.heatmap(correlation_matrix, annot=True)
plt.title('Correlation Matrix for numeric features')

plt.xlabel('Movie features')
plt.ylabel('Movie features')
plt.show()


# In[63]:


df_numerize.corr


# In[64]:


correlation_mat = df_numerize.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[65]:


sorted_pairs = corr_pairs.sort_values()
sorted_pairs


# In[67]:


high_corr = sorted_pairs[(sorted_pairs)>0.5]
high_corr


# In[ ]:





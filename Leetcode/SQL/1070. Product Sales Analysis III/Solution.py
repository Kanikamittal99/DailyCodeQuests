# https://leetcode.com/problems/product-sales-analysis-iii/

import pandas as pd


def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    
    # Using dense_rank() same as SQL here
    sales['Rank'] = sales.groupby('product_id')['year'].rank(method='dense')
    
    # Filtering rows where rank = 1, fetching required columns and renaming them.
    # return sales.loc[sales['Rank'] == 1].iloc[:,[1,2,3,4]].rename(columns={'year':'first_year'})
    return sales.loc[sales['Rank'] == 1, ['product_id', 'year', 'quantity', 'price']].rename(columns={'year': 'first_year'})



## ANOTHER WAY

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:

    # Determine the earliest year for each product
    sales['first_year'] = sales.groupby('product_id')['year'].transform('min')
    
    # Filter rows where year matches first_year
    result = sales[sales['year'] == sales['first_year']]
    
    # Selecting columns 
    
    # result = result.iloc[:, [1, 5, 3, 4]] >> Not Optimal since order of columns might change later on

    return result[['product_id', 'first_year', 'quantity', 'price']]
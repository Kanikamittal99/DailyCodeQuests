import pandas as pd

'''
query method allows you to filter rows in a DataFrame using a query string, similar to SQL-style querying. 
It provides a way to express conditions in a more readable format compared to standard boolean indexing.
    @ symbol is used to reference variables from the local scope inside the query string.
'''
# nunique() : Count number of unique products in each group 
# as_index=False: Ensures that customer_id remains as a column rather than becoming the index of the resulting DataFrame.
# (f"product_key == {len(product)}") : Creates a string that dynamically includes the number of products in the product DataFrame


## REFERENCING VARIABLE IN LOCAL SPACE

def find_customers(customer: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    # Count the number of unique products each customer has purchased
    customer_product_count = customer.groupby('customer_id', as_index=False)['product_key'].nunique()
    
    # Filter customers who have purchased exactly the number of products as in the 'product' DataFrame
    desired_count = len(product)
    filtered = customer_product_count.query('product_key == @desired_count')
    
    # Return the DataFrame with the customer IDs
    return filtered[['customer_id']]



## USING BOOLEAN INDEXING

def find_customers(customer: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    # Count the number of unique products each customer has purchased
    customer_product_count = customer.groupby('customer_id',as_index=False)['product_key'].nunique()
    
    # Filter customers who have purchased exactly the number of products as in the `product` DataFrame
    filtered  = customer_product_count.loc[customer_product_count['product_key']==len(product)]
    
    # Create a DataFrame with the customer IDs who meet the criteria
    return pd.DataFrame(filtered['customer_id'])



## BOOLEAN INDEXING USING f-String - useful for dynamic conditions
'''
Curly braces {} : To insert the result of an expression into the string. In this case, {len(product)} will be replaced by the actual number of products in the product DataFrame.

f"product_key == {len(product)}":

    f": Indicates the start of an f-string.
    "product_key == ": This is a static part of the string.
    {len(product)}: This is an expression embedded in the string.
'''

def find_customers(customer: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    customer_product_count = customer.groupby('customer_id', as_index=False)['product_key'].nunique()
    filtered = customer_product_count.query(f"product_key == {len(product)}")
    return filtered[['customer_id']]
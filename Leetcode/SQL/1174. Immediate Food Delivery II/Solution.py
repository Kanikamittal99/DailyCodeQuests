# https://leetcode.com/problems/immediate-food-delivery-ii/

import pandas as pd


### Using idxmin()

def immediate_food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    # Determine the first order date for each customer
    first_orders = delivery.loc[delivery.groupby('customer_id')['order_date'].idxmin()]
    
    # Calculate the immediate deliveries count
    immediate_count = len(first_orders.loc[first_orders['order_date'] == first_orders['customer_pref_delivery_date']])
    
    # Calculate the total First deliveries count
    total_first_orders = len(first_orders)

    # Return Immediate Percentage (all Dataframe values rounded to 2 places)
    return pd.DataFrame({"immediate_percentage": [immediate_count / total_first_orders *100]}).round(2)


### Using Rank()

def immediate_food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    # Rank deliveries for each customer by min order_date
    # Customer's First order 
    delivery['rk'] = delivery.groupby(['customer_id'])['order_date'].rank()
    delivery = delivery.loc[delivery.rk == 1]
    
    # Fetch only those which are immediate deliveries
    immediate_deliveries = delivery.loc[delivery.order_date == delivery.customer_pref_delivery_date]
    
    return pd.DataFrame({'immediate_percentage':[round(immediate_deliveries.shape[0] / delivery.shape[0] *100, 2)]})
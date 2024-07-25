#https://leetcode.com/problems/percentage-of-users-attended-a-contest/
import pandas as pd
import numpy as np

data = [[6, 'Alice'], [2, 'Bob'], [7, 'Alex']]
users = pd.DataFrame(data, columns=['user_id', 'user_name']).astype({'user_id':'Int64', 'user_name':'object'})
data = [[215, 6], [209, 2], [208, 2], [210, 6], [208, 6], [209, 7], [209, 6], [215, 7], [208, 7], [210, 2], [207, 2], [210, 7]]
register = pd.DataFrame(data, columns=['contest_id', 'user_id']).astype({'contest_id':'Int64', 'user_id':'Int64'})


# Using .agg() 
def users_percentage(users: pd.DataFrame, register: pd.DataFrame) -> pd.DataFrame:
    # as_index argument in groupby() tells whether the grouped by column should be used as the index of the output or not.
    # default value is True
    filtered_df = register.groupby('contest_id', as_index=False).agg(total_count=('user_id',pd.Series.nunique))
    filtered_df['percentage'] = filtered_df['total_count']/len(users)*100
    
    return filtered_df[['contest_id','percentage']].sort_values(by=['percentage', 'contest_id'], ascending=[False, True]).round(2)


# Using .apply()- Creating Series with a single value (percentage)
def users_percentage_another(users: pd.DataFrame, register: pd.DataFrame) -> pd.DataFrame:
    filtered_df = register.groupby('contest_id', as_index=False).apply(lambda x: pd.Series({'percentage': x['user_id'].count() / users.shape[0] * 100}))
    return filtered_df[['contest_id','percentage']].sort_values(by=['percentage', 'contest_id'], ascending=[False, True]).round(2)


    
print(users_percentage(users,register))
print(users_percentage_another(users,register))
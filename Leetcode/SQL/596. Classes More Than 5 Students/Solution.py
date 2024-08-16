#  https://leetcode.com/problems/classes-more-than-5-students/


import pandas as pd

def find_classes(courses: pd.DataFrame) -> pd.DataFrame:
    
    grouped_df = courses.groupby('class')['student'].count().reset_index()
    
    # Efficient : applies the condition and column selection in a single operation.
    return grouped_df.loc[grouped_df['student'] >= 5, ['class']]



# loc[grouped_df['student'] >= 5][['class']] generates an intermediate DataFrame after filtering
# Usecase: if further operations are needed before selecting columns.

# .loc[grouped_df['student'] >= 5, 'class']
# Passed: column name as a string ('class')
# Result: Series
# When you select a single column without using a list, pandas returns a Series instead of a DataFrame.

# .loc[grouped_df['student'] >= 5, ['class']]
#  specifies the column name within a list (['class']).
#  Result: DataFrame. 
# Even though you are selecting a single column, the output retains the DataFrame structure.
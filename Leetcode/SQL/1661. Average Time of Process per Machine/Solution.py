# https://leetcode.com/problems/average-time-of-process-per-machine/

# Input: 
# Activity table:
# +------------+------------+---------------+-----------+
# | machine_id | process_id | activity_type | timestamp |
# +------------+------------+---------------+-----------+
# | 0          | 0          | start         | 0.712     |
# | 0          | 0          | end           | 1.520     |
# | 0          | 1          | start         | 3.140     |
# | 0          | 1          | end           | 4.120     |
# | 1          | 0          | start         | 0.550     |
# | 1          | 0          | end           | 1.550     |
# | 1          | 1          | start         | 0.430     |
# | 1          | 1          | end           | 1.420     |
# | 2          | 0          | start         | 4.100     |
# | 2          | 0          | end           | 4.512     |
# | 2          | 1          | start         | 2.500     |
# | 2          | 1          | end           | 5.000     |
# +------------+------------+---------------+-----------+
# Output: 
# +------------+-----------------+
# | machine_id | processing_time |
# +------------+-----------------+
# | 0          | 0.894           |
# | 1          | 0.995           |
# | 2          | 1.456           |
# +------------+-----------------+

import pandas as pd


# Adding New Column after Pivot() result


def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    # Pivot the DataFrame to get start and end times for each process_id and machine_id
    pivotResult = activity.pivot_table(index=['machine_id', 'process_id'],
                                       columns='activity_type',
                                       values='timestamp',
                                       aggfunc='first')    
    
     # Calculate the processing time by subtracting start times from end times
    pivotResult['processing_time'] = pivotResult['end'] - pivotResult['start']
    
    # Compute the average processing time per machine_id
    return pivotResult.groupby('machine_id')['processing_time'].mean().round(3).reset_index()



# Method chaining 


def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    return activity\
            .pivot(index=['machine_id', 'process_id'], columns='activity_type', values='timestamp')\
            .groupby("machine_id")\
            .apply(lambda x: (x['end'] - x['start']).mean().round(3))\
            .rename("processing_time")\
            .reset_index()
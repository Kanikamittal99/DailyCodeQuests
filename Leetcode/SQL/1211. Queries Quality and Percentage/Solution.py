import pandas as pd

##### Banker's Rounding
# 3.4 → 3 (since 4 < 5)
# 3.5 → 4 (since 5, round to nearest even number which is 4)
# 4.5 → 4 (since 5, round to nearest even number which is 4)
# 5.5 → 6 (since 5, round to nearest even number which is 6)

# If the digit is less than 5, round down (truncate the number).
# If the digit is more than 5, round up.
# If the digit is exactly 5, round to the nearest even number (this is where "bankers' rounding" comes in).


def queries_stats(queries: pd.DataFrame) -> pd.DataFrame:
    # added 0.000001 to all values in rating/position -> that's because pandas functionality of round to nearest even integer
    # This is a small smoothing factor to prevent division by zero.
    queries['quality'] = queries.rating/queries.position + 1e-6
    queries['poor_query_percentage'] = (queries.rating < 3)*100
    # return queries.groupby('query_name').agg({'quality':'mean','poor_query_percentage':'mean'}).round(2).reset_index()
    return queries.groupby("query_name", as_index = False)[["quality","poor_query_percentage"]].mean().round(2)


# Method Chaining

def queries_stats(queries: pd.DataFrame) -> pd.DataFrame:
    return (queries
            .assign(quality=lambda df: df['rating'] / df['position'] + 1e-6,
                    poor_query_percentage=lambda df: (df['rating'] < 3) * 100)
            .groupby('query_name')
            .agg({'quality':'mean', 'poor_query_percentage':'mean'})
            .round(2)
            .reset_index()
           )
"""
Regex Pattern: ^[A-Za-z][A-Za-z0-9_\.\-]*@leetcode(\?com)?\.com$

^               : Anchor the regex pattern to match from the start of the string.
[A-Za-z]        : Match any single uppercase or lowercase letter. The email prefix name must start with a letter.
[A-Za-z0-9_\.\ -]* : Match any number of characters following the first letter in the email prefix name. It includes letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'.
@               : Match the literal '@' character, which separates the prefix name and the domain.
leetcode        : Match the literal 'leetcode', which is part of the email domain.
(?com)?         : Make the sequence ?com optional in the email domain. Allows the pattern to match both '@leetcode.com' and '@leetcode?com'.
.               : Match the literal '.' character, which separates the 'leetcode' part from the 'com' part of the domain.
com             : Match the literal 'com' at the end of the email domain.
$               : Anchor the regex pattern to match until the end of the string.

The regex pattern ensures that a valid email must have the following format:
    The prefix name starts with a letter.
    The prefix name can contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'.
    The domain must be '@leetcode.com' with an optional '?com' part.
"""

import pandas as pd

data = [[1, 'Winston', 'winston@leetcode.com'], [2, 'Jonathan', 'jonathanisgreat'], [3, 'Annabelle', 'bella-@leetcode.com'], [4, 'Sally', 'sally.come@leetcode.com'], [5, 'Marwan', 'quarz#2020@leetcode.com'], [6, 'David', 'david69@gmail.com'], [7, 'Shapiro', '.shapo@leetcode.com'], [8, 'Winston2', 'winston2@leetcode?com']]
users = pd.DataFrame(data, columns=['user_id', 'name', 'mail']).astype({'user_id':'int64', 'name':'object', 'mail':'object'})

def valid_emails(users: pd.DataFrame) -> pd.DataFrame:
    # Use the str.match() method with a regex pattern to find valid emails
    valid_emails_df = users[users['mail'].str.match(r'^[A-Za-z][A-Za-z0-9_\.\-]*@leetcode(\?com)?\.com$')]
    
    return valid_emails_df

valid_emails(users)
import random
import pandas as pd
import re
import sqlite3

first_names = pd.read_csv('firstname.csv')
last_names = pd.read_csv('lastname.csv')
dob = pd.read_csv('fakebday.csv')
address = pd.read_csv('fakeadd.csv')

random.seed(10)
total_users = random.randint(100, 200)

first_names_index = random.sample(range(0, first_names.shape[0]), total_users)
first_name = first_names.iloc[first_names_index]
first_name.reset_index(inplace=True)

last_names_index = random.sample(range(0, last_names.shape[0]), total_users)
last_name = last_names.iloc[last_names_index]
last_name.reset_index(inplace=True)

dob_index = random.sample(range(0, dob.shape[0]), total_users)
dobs = dob.iloc[dob_index]
dobs.reset_index(inplace=True)


address_index = random.sample(range(0, address.shape[0]), total_users)
addresses = address.iloc[address_index]
addresses.reset_index(inplace=True)

def reformat_phone(x):
    phone = re.compile(r'\((\d{3})\) \d{1}(\d{2})-(\d{4})')
    return phone.sub(r'0\2-\3', x)

addresses['phone'] = addresses['phone'].apply(reformat_phone)

cities = pd.DataFrame(
    {
        'city': ['Davis', 'Davis', 'Sacramento', 'Woodland', 'Woodland'],
        'state': 'CA',
        'zip_code': ['95616', '95617', '94203', '95776', '95695'],
        'area_code': ['530', '530', '916', '530', '530']
    }
)

addresses['cities_index'] = [random.randint(0, 4) for x in range(0, total_users)]
addresses = addresses.merge(cities, how='inner', left_on='cities_index', right_index=True)


emails = pd.DataFrame({
    'handle': ['@yahoo.com', '@gmail.com', '@protonmail.com', '@tutanota.com', '@outlook.com', '@icloud.com']
})
addresses['emails_index'] = [random.randint(0, 5) for x in range(0, total_users)]
addresses = addresses.merge(emails, how='inner', left_on='emails_index', right_index=True)


addresses['phone'] = addresses['area_code'] + '-' + addresses['phone']
addresses['phone'].iloc[random.sample(range(0, addresses.shape[0]), 13)] = None


remove_addresses = random.sample(range(0, addresses.shape[0]), 31)

addresses['address'].iloc[remove_addresses] = None
addresses['city'].iloc[remove_addresses] = None
addresses['state'].iloc[remove_addresses] = None
addresses['zip_code'].iloc[remove_addresses] = None


users = pd.DataFrame({
    'id': [x for x in range(1, total_users + 1)],
    'first_name': first_name['firstname'],
    'last_name': last_name['lastname'],
    'birth_date': pd.to_datetime(dobs['birthday']).dt.date,
    'phone': addresses['phone'],
    'email': first_name['firstname'].str.lower().str[0] + '.' + last_name['lastname'].str.lower() + addresses['handle'],
    'address': addresses['address'],
    'city': addresses['city'],
    'state': addresses['state'],
    'zip_code': addresses['zip_code']})

dbconn = sqlite3.connect('lcdb.db')
users.to_sql(con=dbconn, name='users', if_exists='replace', index=False)

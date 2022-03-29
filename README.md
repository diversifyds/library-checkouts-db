# Library Checkouts Database


## Background
The Library Checkouts Database is a fictitious and simulated SQLite database made for learning and practicing SQL.

### Table Definitions

Below are the data definitions of the tables and columns in the Library Checkouts Database.

#### users: All users that have an account with the library

| column | description | data type |
| :--- | :--- | :--- |
| id  | unique id of the user | integer |
| first_name | first name of the user | text |
| last_name | last name of the user | text |
| birth_date | birth date of the user | date |
| phone | cell phone of the user | text |
| email | email address of the user | text |
| address | address where the the user lives | text |
| city | city where the user lives | text |
| state | state where the user lives | text |
| zip_code | zip code where the user lives | integer |

#### checkouts: A log of when a user checks out a book from the library

| column | description | data type |
| :--- | :--- | :--- |
| id  | unique id of the book checkout | integer |
| user_id | id of the user who checked out a book | integer |
| book_id | id of the book that was checked out | integer |
| checkout_date | date the book was checked out by the user | date |
| days\_checking\_out | number of days the user will checkout the book | integer |
| due_date | date the book is due based off days\_checking\_out | date |
| return_date | date the book was returned by the user | date |
| days\_checked\_out | number of days the book was checked out for | integer |
| returned\_with\_damage | a number to distinguish whether the book was returned with damage<br>0 = the book was not returned with damage<br>1 = the book was returned with damage | integer |

#### books: All the books in the library inventory system

| column | description | data type |
| :--- | :--- | :--- |
| id  | unique id of the book | integer |
| title | title of the book | text |
| author | name of the author | text |
| isbn | isbn of the book | text |
| date_published | date the book was published | date |
| publisher | publisher of the book | text |
| format | the format of the book Ex) Hardcover | text |
| pages | the number of pages the book has | integer |

#### book\_genre\_link: A table to link books with their respective genre(s)

| column | description | data type |
| :--- | :--- | :--- |
| book_id | id of the book | integer |
| genre_id | id of the genre | integer |

#### genres: All the genres in the library system

| column | description | data type |
| :--- | :--- | :--- |
| id  | unique id of the genre | integer |
| name | name of the genre | text |


## Prerequisites

- [R](https://cloud.r-project.org/)
    - [RSQLite](https://rsqlite.r-dbi.org/)
    - [openxlsx](https://pandas.pydata.org/)

- [Python](https://www.python.org/downloads/)
    - [sqlite3](https://www.pyinstaller.org/)
    - [pandas](https://pandas.pydata.org/)
    
- [Tableau's Bookshop data set](https://help.tableau.com/current/pro/desktop/en-us/bookshop_data.htm)
    
## Distribution
### Packaged Release
In the [latest release](https://github.com/diversifyds/library-checkouts-database/releases/latest), download the assets

- __lcdb.db__: the SQLite database
- __library-checkouts-erd.png__: the entity relationship diagram of the database

### Build From Source

## Documentation

The database was created using R and Python files.
Refer to each file in the `app` subdirectory for detailed documentation.


`lcdb_ddl.sql`
> A SQL script to create the database table definitions.

`initiliaze.py`
> A Python file to execute `lcdb-ddl.sql`.

`users.py`
> A Python file to create the users table.

`books.R`
> An R file to create the books, genres, and book\_genre\_link tables. 

`checkouts.R`
> An R file to create the checkouts for users and books.


## Resources


## License
<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1"><br>
This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a> 

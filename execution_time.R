# Load the required libraries
library(RSQLite)
library(dplyr)


# whole bunch of junk

# Time some queries that use '=' ---------------------------------------------

time_compare_queries(
  t1 = "
    SELECT title
    FROM Library_OneTable
    WHERE first_name = 'Jane' AND last_name = 'Doe'
  ",
  t2 = "
    SELECT title
    FROM Books
    WHERE author_id = (
      SELECT author_id
      FROM Authors
      WHERE first_name = 'Jane' AND last_name = 'Doe'
    )
  ",
  t3 = "
    SELECT B.title
    FROM Authors A
    JOIN Books B ON A.author_id = B.author_id
    WHERE A.first_name = 'Jane' AND A.last_name = 'Doe'  
  "
)

# Time some queries that use LIKE --------------------------------------------

time_compare_queries(
  t1 = "
      SELECT title
      FROM Library_OneTable
      WHERE first_name LIKE '%J%'
    ",
  t2 = "
      SELECT title
      FROM Books
      WHERE author_id = (
        SELECT author_id
        FROM Authors
        WHERE first_name LIKE '%J%'
      )
    ",
  t3 = "
      SELECT B.title
      FROM Authors A
      JOIN Books B ON A.author_id = B.author_id
      WHERE first_name LIKE '%J%'
    "
)

# Examples of joins performing poorly? --------------------------------------

# After checking these results, run them in SQL Server with:
# SET STATISTICS IO ON
# SET STATISTICS TIME ON

time_compare_queries(
  t1 = "
      SELECT title
      FROM Library_OneTable
      WHERE name LIKE '%fiction%'
    ",
  t2 = "
      SELECT book_id 
      FROM BookGenres 
      WHERE genre_id IN (SELECT genre_id
                        FROM Genres G
                        WHERE G.name LIKE '%fiction%')
    ",
  t3 = "
      SELECT title
      FROM Books B
        JOIN BookGenres BG ON B.book_id = BG.book_id
        JOIN Genres G ON BG.genre_id = G.genre_id
      WHERE G.name LIKE '%fiction%'
    "
)

time_compare_queries(
  t1 = "
      SELECT first_name, last_name, COUNT(*) as num_books
      FROM Library_OneTable
      WHERE name LIKE '%fiction%' 
        AND last_name LIKE 'J%'
      GROUP BY first_name, last_name
    ",
  t2 = "
      SELECT A.first_name, A.last_name, COUNT(*) as num_books
      FROM Authors A
        JOIN Books B ON A.author_id = B.author_id
        JOIN BookGenres BG ON B.book_id = BG.book_id
        JOIN Genres G ON BG.genre_id = G.genre_id
      WHERE G.name LIKE '%fiction%'
        AND A.last_name LIKE 'J%'
      GROUP BY A.first_name, A.last_name
    "
)

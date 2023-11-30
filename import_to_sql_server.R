library(odbc)
library(DBI)
library(RSQLite)


# Connect to SQL Server database
con <- odbc::dbConnect(odbc::odbc(),
                       Driver = "ODBC Driver 17 for SQL Server",
                       Server = "localhost",
                       Database = "master",
                       Authentication = "ActiveDirectoryIntegrated",
                       TrustServerCertificate = "yes")

# Connect to the SQLite database
dblite <- RSQLite::dbConnect(SQLite(), dbname = "library.db")

authors <- DBI::dbReadTable(dblite, "Authors")
genres <- DBI::dbReadTable(dblite, "Genres")
book_genres <- DBI::dbReadTable(dblite, "BookGenres")
books <- DBI::dbReadTable(dblite, "Books")
library_onetable <- DBI::dbReadTable(dblite, "Library_OneTable")


DBI::dbExecute(con, 
  "USE master"
)
DBI::dbExecute(con,
  "DROP DATABASE Library"
)
DBI::dbExecute(con,
  "CREATE DATABASE Library"
)
DBI::dbExecute(con, 
  "USE Library"
)

# create the tables and p/f-keys
DBI::dbExecute(con, "
  CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    first_name varchar(500),
    last_name varchar(500)
  )"
)
DBI::dbExecute(con, "
  CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title varchar(500),
    publication_year INT,
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
  )"
)
DBI::dbExecute(con, "
  CREATE TABLE Genres (
    genre_id INT PRIMARY KEY,
    name varchar(500)
  )
")
DBI::dbExecute(con, "
  CREATE TABLE BookGenres (
    book_genre_id INT PRIMARY KEY,
    book_id INT,
    genre_id INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
  )
")

# write the tables
DBI::dbWriteTable(con, "authors", authors, append = TRUE)
DBI::dbWriteTable(con, "genres", genres, append = TRUE)
DBI::dbWriteTable(con, "books", books, append = TRUE)
DBI::dbWriteTable(con, "bookgenres", book_genres, append = TRUE)
DBI::dbWriteTable(con, "Library_OneTable", library_onetable, append = TRUE)

# Close the database connection
DBI::dbDisconnect(con)
DBI::dbDisconnect(dblite)

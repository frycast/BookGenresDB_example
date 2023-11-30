# Load the required libraries
library(RSQLite)
library(dplyr)

# Connect to the SQLite database
db <- dbConnect(SQLite(), dbname = "library.db")

# Read data from the Authors table
authors <- dbReadTable(db, "Authors")

# Read data from the Books table, including author information using a join
books <- dbReadTable(db, "Books") %>%
  left_join(authors, by = "author_id") %>%
  select(-author_id)  # Remove the author_id column

# Read data from the Genres and BookGenres tables and perform a join
genres <- dbReadTable(db, "Genres")
book_genres <- dbReadTable(db, "BookGenres")

# Combine data from Books, Genres, and BookGenres tables using joins
library_data <- books %>%
  left_join(book_genres, by = "book_id") %>%
  left_join(genres, by = "genre_id")

# write the table as Library_OneTable
dbWriteTable(db, "Library_OneTable", library_data, append = TRUE)

# Close the database connection
dbDisconnect(db)

# Print the first few rows of the combined table
head(library_data)


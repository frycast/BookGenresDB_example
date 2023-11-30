# Load the required libraries
library(RSQLite)
library(dplyr)


  left_join(book_genres, by = "book_id") %>%
  left_join(genres, by = "genre_id")

# write the table as Library_OneTable
dbWriteTable(db, "Library_OneTable", library_data, append = TRUE)

# Close the database connection
dbDisconnect(db)

# Print the first few rows of the combined table
head(library_data)


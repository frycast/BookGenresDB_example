# broken comment
")

# Create the Genres table
dbExecute(db, "
  CREATE TABLE Genres (
    genre_id INTEGER PRIMARY KEY,
    name TEXT
  )
")

# Create the BookGenres table (Many-to-Many Relationship)
dbExecute(db, "
  CREATE TABLE BookGenres (
    book_genre_id INTEGER PRIMARY KEY,
    book_id INTEGER,
    genre_id INTEGER,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
  )
")

# Insert sample data into Authors table
authors <- data.frame(
  first_name = c("John", "Jane", "Robert", "Emily"),
  last_name = c("Doe", "Smith", "Johnson", "Davis")
)
dbWriteTable(db, "Authors", authors, append = TRUE)

# Generate sample data for Books table (large enough for performance testing)
n_books <- 1000000
books <- data.frame(
  title = paste("Book", 1:n_books),
  publication_year = sample(1900:2023, n_books, replace = TRUE),
  author_id = sample(1:4, n_books, replace = TRUE)
)
dbWriteTable(db, "Books", books, append = TRUE)

# Insert sample data into Genres table
genres <- data.frame(
  name = c("Mystery", "Romance", "Science Fiction", "Fantasy", "Thriller", "Non-fiction")
)
dbWriteTable(db, "Genres", genres, append = TRUE)

# Generate sample data for BookGenres table (many-to-many relationship)
n_book_genres <- 1500000
book_genres <- data.frame(
  book_id = sample(1:n_books, n_book_genres, replace = TRUE),
  genre_id = sample(1:6, n_book_genres, replace = TRUE)
)
dbWriteTable(db, "BookGenres", book_genres, append = TRUE)

# Close the database connection
dbDisconnect(db)

# Print a message indicating successful table creation and data insertion
cat("Tables Authors, Books, Genres, and BookGenres created and populated with data.\n")


library(RSQLite)
library(openxlsx)

set.seed(10)
book = read.xlsx("Bookshop.xlsx", sheet = "Book", detectDates = TRUE)
book$id = sample(1:nrow(book), nrow(book), replace = FALSE)

author = read.xlsx("Bookshop.xlsx", sheet = "Author")

info = read.xlsx("Bookshop.xlsx", sheet = "Info")
info$bookid = paste0(info$BookID1, info$BookID2)

edition = read.xlsx("Bookshop.xlsx", sheet = "Edition", detectDates = TRUE)
publisher = read.xlsx("Bookshop.xlsx", sheet = "Publisher")


book2 = merge(book, author, by.x = "AuthID", by.y = "AuthID", all.x = TRUE)
book2_cols = c("BookID", "id",  "Title", "Author")
book2$Author = paste(book2$First.Name, book2$Last.Name)
book2 = book2[, book2_cols]

book3 = merge(book2, info, by.x = "BookID", by.y = "bookid", all.x = TRUE)
book3_cols = c("BookID", "id", "Title", "Author", "Genre")
book3 = book3[, book3_cols]

book4 = merge(book3, edition, by.x = "BookID", by.y = "BookID", all.x = TRUE)
book4$Publication.Date = gsub(pattern = "\\d{2}(\\d{2})-(\\d{2})-(\\d{2})", replacement = "19\\1-\\2-\\3", book4$Publication.Date)
# book4$ISBN = gsub("-", "", book4$ISBN)
book4_cols = c("BookID", "id", "Title", "Author", "ISBN", "Publication.Date",  "Format", "Pages", "PubID", "Genre")
book4 = book4[, book4_cols]


book5 = merge(book4, publisher, by.x = "PubID", by.y = "PubID", all.x = TRUE)
book5_cols = c("BookID", "id",  "Title", "Author", "ISBN", "Publication.Date","Publishing.House", "Format", "Pages", "Genre")
book5 = book5[, book5_cols]

colnames(book5) = c("bookid", "id", "title", "author", "isbn", "date_published","publisher", "format", "pages", "genre")


book5_sorted = book5[order(book5$bookid, book5$date_published),]
book5_ans <- book5_sorted[!duplicated(book5_sorted$bookid),]


book5_ans_cols = c("id", "title", "author", "isbn", "date_published","publisher", "format", "pages", "genre")
book5_ans = book5_ans[, book5_ans_cols]




genres = data.frame(
  id = 1:length(unique(book5_ans$genre)),
  name = unique(book5_ans$genre)
)

book6 = merge(book5_ans, genres, by.x = "genre", by.y = "name")



book_genre_cols = c("id.x", "id.y")
book_genre_link = book6[,book_genre_cols]
book_genre_link = book_genre_link[order(book_genre_link$id.x),]
colnames(book_genre_link) = c("book_id", "genre_id")


ifelse(book_genre_link$genre_id %in% c(2, 3, 4, 8), 
       sample(c(2, 3, 4, 8), sample(1:2, 1)), 
       book_genre_link$genre_id)

L = list()
for (id in 1:nrow(book_genre_link)) {
  if (book_genre_link[id, "genre_id"] %in% c(2, 3, 4, 8)) {
    genre_id = book_genre_link[id, "genre_id"]
    add_genre_ids = sample(c(2, 3, 4, 8), sample(0:2, 1, prob = c(0.30, 0.60, 0.10)))
    new_genres = c(genre_id, add_genre_ids)
  } else {
    new_genres = book_genre_link[id, "genre_id"]
  }
  
  L[[id]] = unique(new_genres)
}

book_genre_link = data.frame(book_id = rep(seq_along(L), lengths(L)), genre_id = unlist(L))
remove_book_genres = sample(1:nrow(book6), 3)
book_genre_link = book_genre_link[!(book_genre_link$book_id %in% remove_book_genres),]


book6_cols = c("id.x", "title", "author", "isbn", "date_published","publisher", "format", "pages")
book6 = book6[book6_cols]
book6_new_cols = c("id", "title", "author", "isbn", "date_published","publisher", "format", "pages")
colnames(book6) = book6_new_cols
book6 = book6[order(book6$id),]

remove_format = sample(1:nrow(book6), 5)
book6$format[remove_format] <- NA

remove_date_published = sample(1:nrow(book6), 4)
book6$date_published[remove_date_published] <- NA

remove_isbn = sample(1:nrow(book6), 3)
book6$isbn[remove_isbn] <- NA


dbWriteTable(conn = db, name = "books", book6, append=TRUE, overwrite=FALSE, row.names=FALSE)
dbWriteTable(conn = db, name = "book_genre_link", book_genre_link, append=TRUE, overwrite=FALSE, row.names=FALSE)
dbWriteTable(conn = db, name = "genres", genres, append=TRUE, overwrite=FALSE, row.names=FALSE)

dbDisconnect(db)

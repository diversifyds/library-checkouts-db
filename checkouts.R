library(RSQLite)

set.seed(10)

book_ids = 1:58
dates = seq(as.Date("2022-03-24"), as.Date("2022-04-11"),  by = 1)
user_ids = sample(173, sample(173, 1))

checkouts = data.frame()

for (x in seq_along(dates)) {
  
  # make sure that no books can overlap while checked out
  # compare the current date and return date
  # checkouts$return_date < dates[]
  checked_out_book_ids = checkouts[dates[x] < checkouts$return_date, "book_id"]
  
  # min and max number of books will be checked out for a given day
  books_in_day = 3:10
  books_size = sample(books_in_day, 1)
  available_books = book_ids[! book_ids %in% checked_out_book_ids]
  books_chosen = sample(available_books, size = books_size)
  
  # user can choose max 2 books in a given day
  user_times = c()
  for (u in seq_along(user_ids)) {
    books_taken_out = sample(2, 1)
    user_times = append(user_times, rep(user_ids[u], books_taken_out))
  }
  users_today = sample(user_times, books_size)

  
  # generate how long a book can be taken out for
  days_checked_out = 1:7
  days_checked_out_prob = c(0.20, 0.30, 0.40, 0.60, 0.85, 0.50, 0.30)
  days_checked_out_books = sample(days_checked_out, size = books_size, replace = TRUE, prob = days_checked_out_prob)
  
  days_actually_out_for = -2:5
  days_actually_out_for_prob = c(0.15, 0.20, 0.50, 0.20, 0.20, 0.15, 0.08, 0.01)
  days_actually_checked_out_for = sample(days_actually_out_for, size = books_size, replace = TRUE, prob = days_actually_out_for_prob)
  
  # days that a booked will be checked out for
  returned_in_days = 
  ifelse(
    days_checked_out_books + days_actually_checked_out_for <= 0,
    days_checked_out_books,
    days_checked_out_books + days_actually_checked_out_for
  ) 
  
  current_date_log = data.frame(
    user_id = users_today,
    book_id = books_chosen,
    checkout_date = as.character(dates[x]),
    days_checking_out = days_checked_out_books,
    due_date = as.character(dates[x] + days_checked_out_books),
    return_date = as.character(dates[x] + returned_in_days),
    days_checked_out = returned_in_days,
    returned_with_damage = sample(0:1, books_size, replace = TRUE, prob = c(0.975, 0.025))
  )
  
  checkouts = rbind(checkouts, current_date_log)
}

checkouts[checkouts$return_date > "2022-04-11", c("return_date", "days_checked_out", "returned_with_damage")] <- NA


db <- dbConnect(SQLite(), dbname="lcdb.db")
dbWriteTable(conn = db, name = "checkouts", checkouts, append=FALSE, overwrite=TRUE, row.names=FALSE)

dbDisconnect(db)


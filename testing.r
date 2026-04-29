source("logic.r")
seq1 <- "AGVRUM"
seq2 <- "ATVRUM"

match_score <- 1
mismatch_penalty <- -1
gap_penalty <- -2

init <- initialize_matrix(seq1, seq2, gap_penalty)

cat("\nInitial Matrix\n")
print(init$my_matrix)

cat("\nInitial Trace\n")
print(init$final_trace)

expected_rows <- length(init$s2) + 1
expected_cols <- length(init$s1) + 1

stopifnot(nrow(init$my_matrix) == expected_rows)
stopifnot(ncol(init$my_matrix) == expected_cols)


filled <- fill_matrix(
  init$my_matrix,
  init$final_trace,
  init$s1,
  init$s2,
  match_score,
  mismatch_penalty,
  gap_penalty,
  animate = FALSE
)

cat("\nFilled Matrix\n")
print(filled$my_matrix)

cat("\nFilled Trace\n")
print(filled$final_trace)


stopifnot(!is.null(filled$my_matrix))
stopifnot(!is.null(filled$final_trace))


result <- traceback_alignment(
  filled$my_matrix,
  filled$final_trace,
  init$s1,
  init$s2
)

stopifnot(nchar(result$align1) == nchar(result$align2))


cat("\nAligment Result\n")
cat("Align1:", result$align1, "\n")
cat("Align2:", result$align2, "\n")

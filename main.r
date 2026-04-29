source("logic.r")

cat("Sequence Alignment Tool\n")
cat("\nUsing scoring system:\n")
cat("Match = +1 | Mismatch = -1 | Gap = -2\n\n")

# ask user for sequences
seq1 <- readline(prompt = "Enter Sequence 1 ")
seq2 <- readline(prompt = "Enter Sequence 2 ")


match_score <- 1
mismatch_penalty <- -1
gap_penalty <- -2

cat("\nTraceback Path (blue):\n")

cat("Sequences:\n")
cat("Sequence 1:", seq1, "\n")
cat("Sequence 2:", seq2, "\n\n")

init <- initialize_matrix(seq1, seq2, gap_penalty)

filled <- fill_matrix(
  init$my_matrix, init$final_trace, 
  init$s1, init$s2, 
  match_score, mismatch_penalty, gap_penalty, 
  animate = TRUE
)

result <- traceback_alignment(
  filled$my_matrix, filled$final_trace, 
  init$s1, init$s2
)

for (p in result$path) {
  cat("\033[34m(", p[1], ",", p[2], ")\033[0m\n")
  Sys.sleep(0.3)
}

color_char <- function(a, b){
  if(a == b){
    return(paste0("\033[32m", a, "\033[0m"))  # green
  } else if (a == "-" || b == "-") {
    return(paste0("\033[33m", a, "\033[0m"))  # yellow gap
  } else {
    return(paste0("\033[31m", a, "\033[0m"))  # red mismatch
  }
}

a1 <- strsplit(result$align1, "")[[1]]
a2 <- strsplit(result$align2, "")[[1]]

line1 <- ""
line2 <- ""

for (k in 1:length(a1)){
  line1 <- paste0(line1, color_char(a1[k], a2[k]), " ")
  line2 <- paste0(line2, color_char(a2[k], a1[k]), " ")

}
cat("\nColored Alignment:\n")
cat(line1, "\n")
cat(line2, "\n")

cat("\nTraceback Path (blue):\n")

for (p in result$path) {
  cat("\033[34m(", p[1], ",", p[2], ")\033[0m\n")
  Sys.sleep(0.3)
}
path_set <- lapply(result$path, function(p) paste0(p[1], "_", p[2]))

cat("\nFinal Matrix (traceback path highlighted in blue):\n\n")

my_matrix   <- filled$my_matrix
final_trace <- filled$final_trace
row     <- nrow(my_matrix)
column     <- ncol(my_matrix)

# header row: column labels (seq1 chars)
cat(sprintf("%6s", ""))       # top-left corner blank
cat(sprintf("%6s", " "))      # blank above the gap column
for (ch in init$s1) cat(sprintf("%6s", ch))
cat("\n")

for (i in 1:row) {
  # row label: seq2 chars (first row is the gap row)
  if (i == 1) cat(sprintf("%6s", " ")) else cat(sprintf("%6s", init$s2[i-1]))

  for (j in 1:column) {
    key     <- paste0(i, "_", j)
    cell    <- sprintf("%4d", dp[i, j])
    if (key %in% path_set) {
      cat("\033[34m", cell, "\033[0m", sep = "")   # blue for path
    } else {
      cat("\033[90m", cell, "\033[0m", sep = "")   # dim grey otherwise
    }
    cat("  ")
  }
  cat("\n")
}

matches    <- 0
mismatches <- 0
gaps       <- 0

for (k in 1:length(a1)) {
  if (a1[k] == "-" || a2[k] == "-") {
    gaps <- gaps + 1
  } else if (a1[k] == a2[k]) {
    matches <- matches + 1
  } else {
    mismatches <- mismatches + 1
  }
}

total_score <- matches * match_score + mismatches * mismatch_penalty + gaps * gap_penalty

cat("\nScore Summary\n")
cat("Matches :", matches,    " (", matches    * match_score,    " pts)\n")
cat("Mismatches :", mismatches, " (", mismatches * mismatch_penalty, " pts)\n")
cat("Gaps :", gaps,       " (", gaps       * gap_penalty,    " pts)\n")
cat("Total Score :", total_score, "\n")



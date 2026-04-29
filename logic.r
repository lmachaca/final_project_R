
initialize_matrix <- function(seq1, seq2, gap_penalty) {
  s1 <- strsplit(seq1, "")[[1]] #break
  s2 <- strsplit(seq2, "")[[1]]

  row <- length(s2) + 1 #calcualte the matrix we EXTRA column and row. 
  column <- length(s1) + 1

  my_matrix <- matrix(0, nrow = row, ncol = column) # creates the matrix and eventually will be filled with zeros
  final_trace <- matrix("", nrow = row, ncol = column) # we store the trace diag, uo or left.

  # initilize frist column 
  for (i in 2:row ){
    my_matrix[i,1] <- my_matrix[i-1,1] + gap_penalty
    final_trace[i, 1] <- "up"
  }

  # initialize 1st row
  for (j in 2:column) {
    my_matrix[1,j] <- my_matrix[1,j-1] + gap_penalty
    final_trace[1,j] <- "left"
  }

  list(
    my_matrix = my_matrix,
    final_trace = final_trace,
    s1 = s1,
    s2 = s2
  )
}


fill_matrix <- function(my_matrix, final_trace, s1, s2, 
                        match_score, mismatch_penalty, gap_penalty, animate = TRUE){

  row <- nrow(my_matrix)
  column <- ncol(my_matrix)

  for (i in 2:row){
    for(j in 2:column) {

      if (s2[i-1] == s1[j-1]) {
        diag <- my_matrix[i-1, j-1] + match_score
      } else {
        diag <- my_matrix[i-1, j-1] + mismatch_penalty
      }

      up <- my_matrix[i-1, j] + gap_penalty
      left <- my_matrix[i, j-1] + gap_penalty

      max_score <- max(diag, up, left)
      my_matrix[i,j] <- max_score

      if (max_score == diag) {
        final_trace[i,j] <- "diag"
      } else if (max_score == up){
        final_trace[i,j] <- "up"
      } else {
        final_trace[i,j] <- "left"
      }

      #animation step 

      if(animate){
        cat("\nFilling cell( ", i, ",", j, ")\n")
        print(my_matrix)
        Sys.sleep(0.5)
      }
    }
  }

  list(my_matrix = my_matrix, final_trace = final_trace)
}


traceback_alignment <- function(my_matrix, final_trace, s1, s2) {

  i <- nrow(my_matrix)
  j <- ncol(my_matrix)

  align1 <- ""
  align2 <- ""

  path <- list()

  while (i > 1 || j > 1) {

    path <- append(path, list(c(i,j)))

    move <- final_trace[i,j]

    if (move == "diag") {
      align1 <- paste0(s1[j-1], align1)
      align2 <- paste0(s2[i-1], align2)

      i <- i-1
      j <- j-1
    }
    else if (move == "up") {
      align1 <- paste0("-", align1)
      align2 <- paste0(s2[i-1], align2)
      i <- i-1
    } else {
      align1 <- paste0(s1[j-1], align1)
      align2 <- paste0("-", align2)
      j <- j-1
    }
  }

  list(align1 = align1, align2 = align2, path = path)
}
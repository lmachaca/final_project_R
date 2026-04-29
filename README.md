# Sequence Alignment (Needleman–Wunsch Algorithm in R)

## Overview

This project implements a global sequence alignment algorithm based on the Needleman–Wunsch method. It compares two biological or general sequences and computes the optimal alignment using dynamic programming.

The program builds a scoring matrix, tracks optimal moves, and reconstructs the final alignment using traceback.

---

## Problem Being Solved

The goal of this project is to determine the best possible alignment between two sequences by allowing:

- Matches (same characters)
- Mismatches (different characters)
- Gaps (insertions or deletions)

This is useful in bioinformatics for comparing DNA, RNA, or protein sequences.

---

## How the Algorithm Works

The solution has three main steps:

### 1. Matrix Initialization
- Sequences are split into individual characters
- A scoring matrix is created with an extra row and column
- First row and column are filled using gap penalties
- A trace matrix is created to store movement directions:
  - "diag"
  - "up"
  - "left"

---

### 2. Matrix Filling (Dynamic Programming)
For each cell in the matrix:

- Compute diagonal score (match or mismatch)
- Compute up score (gap in sequence 1)
- Compute left score (gap in sequence 2)
- Choose the maximum score
- Store the direction in the trace matrix

This ensures that every cell represents the optimal local decision.

---

### 3. Traceback
- Start from bottom-right of the matrix
- Follow directions stored in trace matrix
- Build aligned sequences backwards:
  - "diag" → match/mismatch
  - "up" → gap in sequence 1
  - "left" → gap in sequence 2

---

## Functions

### `initialize_matrix(seq1, seq2, gap_penalty)`
Creates and initializes:
- scoring matrix
- trace matrix
- split sequences

Returns a list containing all components.

---

### `fill_matrix(my_matrix, final_trace, s1, s2, match_score, mismatch_penalty, gap_penalty)`
Fills the scoring matrix using dynamic programming and records traceback directions.

Returns:
- completed scoring matrix
- completed trace matrix

---

### `traceback_alignment(my_matrix, final_trace, s1, s2)`
Reconstructs the optimal alignment by following the trace matrix backward.

Returns:
- aligned sequence 1
- aligned sequence 2
- path of traversal

---

## Scoring System

- Match: +1 (or user-defined)
- Mismatch: penalty (e.g., -1)
- Gap: penalty (e.g., -2)

---

## Example Output
Sequence 1: AGT
Sequence 2: A-T

Alignment:
AGT
A-T

---

## Key Concepts Used

- Dynamic Programming
- Matrix Manipulation in R
- Traceback Reconstruction
- String Processing
- Greedy decision tracking per cell

---

## Learning Outcomes

This project demonstrates:
- How complex problems can be broken into subproblems
- How optimal solutions are built step-by-step
- How to reconstruct solutions from stored decisions

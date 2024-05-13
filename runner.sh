#!/bin/sh

# Check for the "list" argument to list all question numbers
if [ "$1" = "list" ]; then
  echo "Available questions:"
  ls /problems
  exit 0
fi

# Check command line arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: asmcoderunner <question number> <solution file> or asmcoderunner list"
  exit 1
fi

QUESTION=$1
SOLUTION=$2

# Check if the problem exists
if [ ! -f "/problems/$QUESTION/expected_output.txt" ]; then
  echo "Invalid question number."
  exit 1
fi

# Assemble the student's solution using NASM
nasm -f elf64 $SOLUTION -o solution.o

# Link using ld to avoid standard C startup files
ld -o solution solution.o

# Run the solution and capture the output
OUTPUT=$(./solution)

# Check the output against the expected
if [ "$OUTPUT" = "$(cat /problems/$QUESTION/expected_output.txt)" ]; then
  echo "Correct"
else
  echo "Incorrect"
fi

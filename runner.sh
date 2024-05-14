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

# Assemble the student's solution using NASM for 64-bit
nasm -f elf64 $SOLUTION -o solution.o
if [ $? -ne 0 ]; then
    echo "Assembly failed."
    exit 1
fi

# Link using ld to avoid standard C startup files and target 64-bit, include the C library
ld -m elf_x86_64 -o solution solution.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 2>&1 | tee link_errors.txt
LINK_STATUS=$?
if [ $LINK_STATUS -ne 0 ]; then
    echo "Linking failed. See 'link_errors.txt' for details."
    exit 1
fi

# Ensure the solution is executable
chmod +x solution

echo "Running the solution executable..."
OUTPUT=$(./solution)
echo "Solution output:"
./solution
echo "Execution completed."

# ldd solution
# nm solution.o
# nm solution
# objdump -D solution

if [ $? -ne 0 ]; then
    echo "Execution failed."
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check the output against the expected
if [ "$OUTPUT" = "$(cat /problems/$QUESTION/expected_output.txt)" ]; then
    echo "${GREEN}Correct!${NC}"
else
    echo "${RED}Incorrect${NC}"
    echo "Your output:"
    echo "${RED}$OUTPUT${NC}"
    echo "Expected output:"
    echo "${GREEN}$(cat /problems/$QUESTION/expected_output.txt)${NC}"
fi
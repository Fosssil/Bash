#!/usr/bin/env bash
#Find the sum of first "N" numbers in Fibonacci series
echo -e "\033[0;35mEnter range for fibonacci series\033[0m"
read -r N
# First Number of the
# Fibonacci Series
a=0
# Second Number of the
# Fibonacci Series
b=1
echo -e "\033[0;35mThe Fibonacci series is : \033[0m"
for ((i = 0; i < N; i++)); do
	# printing fibonacci series
	echo -e "\033[0;32m$a\033[0m"
	c=$(((a + b) - 1))
	fn=$((a + b))
	a=$b
	b=$fn

done
# sum of fibonacci series
echo -e "\033[0;33m And there sum is : $c"

#!/usr/bin/env bash
read -rp "Enter first strings: " str1
read -rp "Enter first strings: " str2
if [ "$str1" == "$str2" ]; then
    echo "Strings are Equal"
else
    echo "Strings are not equal"
fi
if [ "$str1" == "" ] || [ "$str2" = "" ]; then
    echo "String is empty."
else
    echo "String is not empty."
fi
if [[ $str1 == *['!'@#\$%^\&*()_+]* ]]; then
    echo "First string contains special character"
else
    echo "First string does not contains special character"
fi
if [[ $str2 == *['!'@#\$%^\&*()_+]* ]]; then
    echo "Second string contains special character"
else
    echo "Second string does not contains special character"
fi

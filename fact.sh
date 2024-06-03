#!/bin/bash
echo '



                        `````````````````````
                        `   Linux Rules!    `
                        `                   `
                        `````````````````````

               THIS SCRIPT IS MADE BY "Sagar Dahiya"
                  follow on ~ github.com/Fosssil



'
HEIGHT=20
WIDTH=50
CHOICE_HEIGHT=5
BACKTITLE="by Sagar Dahiya"
TITLE="Made by Sagar Dahiya"
MENU="Choose one of the following options:"

OPTIONS=(1 "Factorial of a given NO."
         2 "Sum of first N natural No."
         3 "Display Prime Number upto a given number")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "Enter a number"
            read num

            fact=1

            while [ $num -gt 1 ]
            do
            fact=$((fact * num))  #fact = fact * num
            num=$((num - 1))      #num = num - 1
            done
            echo -e "Factorial of number = $fact"
            ;;

        2)
            echo "Enter the number of N"
            read n  
            sum=0
            for (( i=0; i<=n; i++ ))
            do
            sum=$((sum + i))
            done
            echo -e "The sum of first N number = $sum"
            ;;


        3)
            echo "Enter a limit"
            read limit
            echo "prime numbers upto $limit are :"
            echo "1"
            i=2
            while [ $i -le $limit ]
            do
                flag=1
                j=2    
            while [ $j -lt $i ]
            do
                rem=$(( $i % $j ))
                if [ $rem -eq 0 ]
                then
                flag=0
                break
                fi
                j=$(( $j+1 ))
            done
            if [ $flag -eq 1 ]
            then
            echo "$i"
            fi
            i=$(( $i+1 ))
            done
            ;;
esac



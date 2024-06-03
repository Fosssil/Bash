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

OPTIONS=(1 "Convert Binary no. into Decimal no."
         2 "Reverse a given N digit no."
         )

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
           echo "Enter any Binary no= "
            read bino
            len=${#bino}
            i=1
            pow=$((len - 1 ))
            while [ $i -le $len ]
            do
                n=`echo $bino | awk '{ printf substr( $0,'$i',1 )}' `
                j=1
                p=1
            while [ $j -le $pow ]
            do
                p=$(( p * 2 ))
                j=$(( j + 1 ))
            done
            dec=$(( n * p ))
            findec=$(( findec + dec ))
            pow=$((pow - 1 ))
            i=$(( i + 1 ))
            done
            echo "Equivalent Decimal no= "$findec ;;

        2)
            echo "Enter no. to reverse= "
            read n
            sd=0
            rev=0
            while [ $n -gt 0 ]
            do
                sd=$(( $n % 10 ))
                rev=$(( $rev * 10 + $sd ))
                n=$(( $n / 10 ))
            done
            echo "Reverse number of entered digit is $rev" ;;  
esac



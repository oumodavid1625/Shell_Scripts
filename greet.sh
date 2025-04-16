#!/bin/bash

name="Long John"

echo  "Hello, $name"

name="Alice"
age=25

echo "My name is $name"
echo "I am $age years old"

echo "what is your favorite color?"
read color

echo "Your favorite color is $color"

# Variable naming rules
# You can use letters, numbers and underscores
# Must start with a letter or underscore
# No spaces around =
# Avoid using the special characters


date_today=$(date)
echo "Today is: $date_today"

echo "Enter your name:"
read name
echo "Hello, $name"

# The command below:
# -gt means "greater than"
# [ $number -gt 10 ] tests if  $number is greater than 10
# fi closes the if-statement

echo "Enter a number:"
read number

if [ $number -gt 10 ]
then
    echo "The number is greater than 10."
fi

# illustration
# if [ condition ]
# then
#     commands
# else
#     other_commands
# fi

echo "Enter your age: "
read age

if [ $age -gt 18 ]
then 
    echo "You are an adult."
else
    echo "You are a minor."
fi

######################################

echo "Enter your score:"
read score

if [ $score -ge 80 ]
then
    echo "Grade: A"
elif [ $score -ge 60 ]
then
    echo "Grade: B"
elif [ $score -ge 40 ]
then
    echo "Grade: C"
else
    echo "Grade: F"
fi

####################################

# Common comparison operators

# -eq              Equal to
# -ne              Not equal to
# -gt              Greater than
# -lt              Less than
# -ge              Greater than or equal to
# -le              Less than or equal to


#############################################

# Test

# -e file      checks if the the file exists
# -f file      checks if the file exists and is a regular file
# -d directory checks if the directory exists

####################################################

echo "Enter a filename:"
read filename

if [ -f $filename ]
then
    echo "File exists."
else
    echo "file does not exist."
fi

################################################

echo "Enter your age:"
read age

if [ $age -ge 18 -a $age -le 30 ]
then
    echo "You are in the youth category."
fi


# -a    used for and (AND)
# -o    used for or (OR)

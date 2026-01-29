# #! /usr/bin/bash   # this is very explicit path, just run and i'm confident that bash exist with the provided path
# #! /usr/bin/env bash # it is telling to find the bash and then run
# echo "Hello World!"


# variables
# name="ashish shah" # there should not be space
# echo "Hi, $name"

# to take value from user
# name=$1  # bash script.sh ashish or "Ashish Shah"
# echo "hi, $name"


# pass data when executing the script
# echo "Enter your name: "
# name=$1
# echo "Hi, $name Welcome to pied piper"

# take the values dynamically(when script is running)
# echo "Enter your name: "
# read name
# echo "Hi, $name welcome to server room"


# arrays: indexed array
# language=(javascript golang java python)

# # access item with index
# echo ${language[1]}
# echo ${language} # first value only

# # list all items 
# echo ${language[@]}

# get lenght of the array
# echo ${#language[@]}



language=(javascript golang java python)
# loop
# for((i=0; i<${#language[@]}; i++)); do
#     echo "index $i = value ${language[$i]}"
# done

# for-in loop
for lang in "${language[@]}"; do
    echo "$lang"
done
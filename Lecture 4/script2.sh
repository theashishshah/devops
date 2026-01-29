#! /usr/bin/env bash

# maps: key value pair

# declare -A prices # associate array
# prices[pizza]=100
# prices[salad]=200
# prices[rolls]=133

# echo prices[pizza]


# control-flow: if else
# points=40
# if [ $points -gt 10 ]; then # both side a single space in square bracket
#     echo "You are passed"
# else 
#     echo "You failed"
# fi


# create a file if does not exist
# if [ -f hello.txt ]; then 
#     echo "File already exist"
# else 
#     echo "Creating hello.txt file"
#     touch hello.txt
# fi


# create a dir if does not exist or give appropriate message if dir already exist
# if [ -d notes ]; then
#     echo "Directory already exist"
# else 
#     echo "Creating a new directory"
#     mkdir notes
# fi


# to loop in dir or file
# for file in *.*; do # for file if you give extension
#     echo "$file"
# done
# for file in *; do # for dir
#     echo "$file"
# done



# # to write into file
# echo "this is my data" >> data.txt # to write
# echo "to append data" > data.txt # to append the data into existing file

# how can i read and write data btw two files




# cat <<EOF> about.txt # cat end of file of about.txt and then write
# this is a data
# this is also a data 
# this is another data
# EOF


# functions
# greet(){
#     echo "heelo, $1"
# }
# greet Ashish
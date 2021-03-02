#!/bin/bash
echo "Downloading $1 source"
wget -O index.html $1 -q
if [[ !  -d ~/homework2/ ]]
then
echo "Directory homework2 does not exist" 
mkdir ~/homework2
echo "Directory created"
fi
echo "Processing file ..."
less index.html | grep "\w*a\w*" -o -w -i >> ~/homework2/$2
wc -l ~/homework2/$2 | cut -d' ' -f1 >> ~/homework2/$2
echo "File $2 has been successfully created in directory homework2"


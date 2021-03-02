#!/bin/bash 
source ~/homework1/filterscript.sh

uniquefilename="output.$RANDOM"
echo "Preparing file for commit... "
touch ~/homework2/$uniquefilename
echo $uniquefilename
cat ~/homework2/$2 > ~/homework2/$uniquefilename
cd ~/homework2/
echo "File prepared, starting GIT push process" 
git add $uniquefilename
while :
do
echo "Do you need custom commit message or random one?(Type 1 for random or 2 for custom)"
read var
if [[ $var -eq 1 ]] ; then
git commit -m "commit ID: $RANDOM"
break
elif [[ $var -eq 2 ]]; then 
echo "Please type the commit message below:"
read var2
git commit -m "$var2"
break
else
echo "Please enter a valid input" 
continue
fi
done
echo "Pushing files to remote repo"
git push -u origin main 
echo "Files successfuly pushed to remote repo"



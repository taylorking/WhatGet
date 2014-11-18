#!/bin/bash

# Taylor King 2014
# A script to go to what.cd and get all freeleach torrents 
#

rm -f .cookies.txt .urls .sitedata .cleardata
mkdir torrents

export username=`cat user_info.txt | grep username | cut -d':' -f 2 | sed s/\ //g`
export password=`cat user_info.txt | grep password | cut -d':' -f 2`


curl -c ".cookies.txt" --url "https://what.cd/login.php" > /dev/null  # Login and get a cookie

curl --data "username=$username&password=$password&submit=login" -b ".cookies.txt" -c ".cookies.txt" --url "https://what.cd/login.php" # Get a cookie and login
rm -f .sitedata # delete the data from the previous go if it exists
for i in `seq 1 5`;
do
  curl -b ".cookies.txt" -c ".cookies.txt" --url "https://what.cd/torrents.php?page=$i&freetorrent=1" -o .sitedata 
done
sed 's/\&amp;/\&/g' .sitedata > .cleardata # replace curls &amp; with a regular &
cat .cleardata | grep DL | cut -d'"' -f 2 > .urls
while read j; 
  do
    curl -c ".cookies.txt" --url "https://what.cd/$j" -o "torrents/`echo $j | cut -d'&' -f 2 | cut -d'=' -f 2`.torrent"
done < .urls




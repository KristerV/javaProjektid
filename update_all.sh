#!/bin/sh

# set -e # exit immediately if a command fails

# Init repos that are in .gitmodules but not cloned yet
echo ""
echo "----------------------- reinit nonexisting ---------------------------"
git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
    while read path_key path
    do
        url_key=$(echo $path_key | sed 's/\.path/.url/')
        url=$(git config -f .gitmodules --get "$url_key")
        if [ ! -d "$path" ]; then
            git submodule add $url $path
        fi
    done

# Pull updates
echo ""
echo "----------------------- pull updates ---------------------------"
git submodule foreach git pull origin master

# Make sure checkout is at tip of master
echo ""
echo "----------------------- checkout master ---------------------------"
git submodule foreach git checkout master

echo ""
echo "----------------------- commit changes ---------------------------"
git add --all
git commit -m "update repos"
git push

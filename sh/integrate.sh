#!/bin/sh
REPOSDIR=/home/lana/repos/
ERRFILE=$REPOSDIR$(od -t uI -N 4 /dev/urandom | awk '{print $2}')
REPO=$1
BRANCH=$2
TEST=$3
CONTAIN=$4

cd $REPOSDIR$REPO
git fetch origin
git merge origin/$BRANCH -X theirs

if [ $TEST = "true" ]
then
    npm test 2> $ERRFILE
    if [ -s $ERRFILE ]
    then
        cat $ERRFILE 2>&1
        rm $ERRFILE
        exit 1
    fi
fi

if [ $CONTAIN = "true" ]
then
    docker build -t=$REPO .
    docker save -o $REPOSDIR$REPO.tar $REPO
fi

exit 

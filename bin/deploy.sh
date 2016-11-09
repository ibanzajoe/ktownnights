#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
dest=$1
dest="jae@ktowncupid.com"
rsync -avzr $parentdir $dest:~/sites/ && ssh $dest "cd ~/sites/$app && docker-compose stop && docker-compose -f docker-compose.yml up && docker-compose logs"

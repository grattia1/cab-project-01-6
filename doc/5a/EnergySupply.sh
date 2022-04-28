#! /bin/bash

dropdb project1;
createdb project1;

psql -U postgres -d project1 < /home/lion/cab-project-01-6/doc/5a/createDB.sql
sh ./populateDB.sh
psql -U postgres -d project1 < /home/lion/cab-project-01-6/doc/5a/createviews.sql

[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=6874447&assignment_repo_type=AssignmentRepo)

## Overview:
This project is a flask web app that uses PostgreSQL as its database.

## How to install:

#### One time installation for Linux Manjaro:
```
# install python pip and psycopg2 packages
sudo pacman -Syu
sudo pacman -S python-pip python-psycopg2

# install flask
pip install flask
```

#### Usage:
To run the flask app, run:
```
export FLASK_APP=app.py
flask run
# then browse to http://127.0.0.1:5000/
```

## Files:
Everything you need for this project is inside the ```src``` folder. There are two important files inside the ```src``` Folder:
- src
- Database

### src Folder:
The following files can be found inside:
- app.py
  - The file you run to run the web app
- database.ini
  - make sure to set the database to ```energydb``` or whatever your psql database is called
- tempalates:
  - Contains all the .html files that the web app utilizes

### Database/newDB Folder:
This is where you need to create the database and populate it with the data that was given.

##### First:
In a terminal window, navigate to the ```newDB``` folder and run:
```
createdb energydb
psql energydb
```
Then inside the psql, run:
```
energydb=#  \i createDB.sql
energydb=#  quit
```
After you create all the tables and exit the psql, make sure you change the directory lines inside the populateDB.sh and point it to the directory where the .csv files are. Then run the following in the command line:
```
chmod 755 -v populateDB.sh
bash populateDB.sh
```
After doing so, navigate back to the psql using ```psql energydb``` and run:
```
energydb=#  \i createviews.sql
energydb=#  quit
```
After doing so, you should be all good to run ```flask run``` and then navigate to ```http://127.0.0.1:5000/```

## Contributors
Karam Hallak
Yehuda Binik
Saki Mertis
Joe Fardella
Matthew Petrovic
James C. S.
Andrew Gratti

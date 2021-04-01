#!/usr/bin/python

# 3. python -m dbbot -b mysql:/grafanaReader:de1234@localhost:/Users/sreelesh/Documents/USTGlobal/reports
# 1. CREATE DATABASE robot_results;
# 2. CREATE USER 'grafanaReader' IDENTIFIED BY 'password';
#    GRANT ALL PRIVILEGES ON *.* TO 'grafanaReader'@'%' WITH GRANT OPTION;


import sqlite3

conn = sqlite3.connect('test.db')

print "Opened database successfully";

# H2 Database Setup

This project contains the needed scripts to populate a H2 database file that can then be used to run the [plant-simulator](https://github.com/joesan/plant-simulator/) application.

There are also scripts to generate a massive amount of data as a H2 database file so that we can run load test on the plant-simulator.

The instructions below will help you get started!

## Application Database

We have several options here to generate a database file. We go through each one of them. You can pick one of the options based on your convenicene!

#### 1. Classical approach

The classical way to generate a database file is to run the .sql script using a database explorer. Since, there is some detailed instruction on how to do this. Have a look [here](http://www.h2database.com/html/tutorial.html#creating_new_databases) and [here](http://www.h2database.com/html/tutorial.html#tutorial_starting_h2_console). 

Assuming that you have the h2 jar file downloaded locally on your machine, open the H2 console and simply run the power_plant_sim_setup.sql [script](https://github.com/joesan/database-projects/blob/master/power-plant-simulator/h2/scripts/database/power_plant_sim_setup.sql)

#### 2. Using Bash

#### 3. Using Ammonite

If you find the classical way too boring, you have the option to populate the database file by running an [Ammonite](http://ammonite.io/#ScalaScripts) script.

## Application Load Test Database

To generate the database file for load testing, we have here 2 option. Again feel free to choose one!

#### 1. Using Bash

#### 2. Using Ammonite

```
./db-generator.sh
```

A few notes on the db-generator.sh script:

1. If you want to put more load on the application, just increase the number of PowerPlant's by modifying the script
   val totalPowerPlants = 1000000 // Set this number to your liking!
   
2. The H2 database file will be generated after you run this script. You can then copy this database file to your power-plant    simulator project's root folder location on your local machine.   

There is yet another script that you can use once your application is up and running with the database file from the above step. 

```
./dispatch.sh
```

A few notes on the dispatch.sh script:

1. This script contains the dispatch commands for the PowerPlant's. We assume that all PowerPlant's with a even PowerPlant Id    is a RampUpType PowerPlant and all the PowerPlant's with an odd PowerPlant Id is an OnOffType PowerPlant. More Information    on the PowerPlant types can he found [here](https://github.com/joesan/plant-simulator/wiki)

2. To modify the script for matching the total number of PowerPlant's that you created from the db-generator.sh script, you      can modify the following parameter:
   val totalPowerPlants = 1000000 // Set this number to match the totalPowerPlants count from the db-generator.sh
   
Once you start the dispatch.sh script, stay calm and have a cup of coffee!

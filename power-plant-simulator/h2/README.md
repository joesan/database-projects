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

To generate the database file for the project, you could run the following script

```
./db-generator.sh
```

A few notes on the db-generator.sh script:

1. Just make sure that you do not have an insane number for PowerPlant's so that you can try all the API's quickly
   val totalPowerPlants = 10 // 10 PowerPlant's would be a good number to start with
   
2. The H2 database file will be generated after you run this script. You can then copy this database file to your power-plant    simulator project's root folder location on your local machine. The generated database file can be found under the project    root folder.

#### 3. Using Ammonite

If you find the classical way of generating a database file too boring, you have the option to populate the database file by running an [Ammonite](http://ammonite.io/#ScalaScripts) script. But this comes with its own complexity which is installing Scala, SBT and Ammonite. But I assume that you might already have Scala and SBT installed, so just go and install [Ammonite](http://ammonite.io/#ScalaScripts)

Now that you have ammonite installed, just open a bash window and run the following command:

```
./db-generator.sc
```

A few notes on the script:

1. You will otice that the [Ammonite script uses the ivy resolution](http://ammonite.io/#import$ivy) for resolving external      dependencies. So, you do not have to have a local copy of the dependant jar files like we have for the bash shell script      option to generate the database file.

2. Just make sure that you do not have an insane number for PowerPlant's so that you can try all the API's quickly
   val totalPowerPlants = 10 // 10 PowerPlant's would be a good number to start with
   
3. The generted database filw is to be found under the project's root directory.

4. TODO... Document how to make use of the application.conf????

## Application Load Test Database

To generate the database file for load testing, we have here 2 option. Again feel free to choose one!

#### 1. Using Bash

First, you run the following script to generate the database file:

```
./db-generator.sh
```

A few notes on the db-generator.sh script:

1. Unlike the database file for just running the application, here the goal would be to have as many PowerPlant's as you might    want so that you can really stress the application. So just increase the number of PowerPlant's by modifying the script
   val totalPowerPlants = 1000000 // Set this number to your liking! I have it here set for a million
   
2. The H2 database file will be generated after you run this script. You can then copy this database file to your power-plant    simulator project's root folder location on your local machine. The generated database file can be found under the project    root folder.   

There is yet another script that you can use once your application is up and running with the database file from the above step. 

```
./dispatch.sh
```

A few notes on the dispatch.sh script:

1. This script contains the dispatch commands for the PowerPlant's. We assume that all PowerPlant's with a even PowerPlant Id    is a RampUpType PowerPlant and all the PowerPlant's with an odd PowerPlant Id is an OnOffType PowerPlant. More Information    on the PowerPlant types can he found [here](https://github.com/joesan/plant-simulator/wiki)

2. To modify the script for matching the total number of PowerPlant's that you created from the db-generator.sh script, you      can modify the following parameter:
   val totalPowerPlants = 1000000 // Set this number to match the totalPowerPlants count from the db-generator.sh

#### 2. Using Ammonite
   
Once you start the dispatch.sh script, stay calm and have a cup of coffee!

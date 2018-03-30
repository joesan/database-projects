To generate the data for load testing, just run the following script:

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

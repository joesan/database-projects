#!/bin/sh
exec scala "$0" "$@"
!#

/***
scalaVersion := "2.11.11"

libraryDependencies ++= Seq(
  "com.typesafe.slick" %% "slick" % "3.2.0",
  "com.h2database" % "h2" % "1.4.186"
)
*/

import java.io.File
import sys.process._

import slick.driver.H2Driver.api._
import scala.concurrent.ExecutionContext.Implicits.global

/**
 * The goal of this file is to spit out a H2 database that
 * can be used to load test the plant-simulator application
 */
object DockerBuild {

  // Slick mapping files
    class PowerPlantTable(tag: Tag)
      extends Table[PowerPlantRow](tag, "powerPlant") {
    def id = column[Option[Int]]("powerPlantId", O.PrimaryKey)
    def orgName = column[String]("orgName")
    def isActive = column[Boolean]("isActive")
    def minPower = column[Double]("minPower")
    def maxPower = column[Double]("maxPower")
    def powerRampRate = column[Option[Double]]("rampRate")
    def rampRateSecs = column[Option[Long]]("rampRateSecs")
    def powerPlantType = column[PowerPlantType]("powerPlantType")
    def createdAt = column[DateTime]("createdAt")
    def updatedAt = column[DateTime]("updatedAt")

    def * = {
      (id,
       orgName,
       isActive,
       minPower,
       maxPower,
       powerRampRate,
       rampRateSecs,
       powerPlantType,
       createdAt,
       updatedAt) <>
        (PowerPlantRow.tupled, PowerPlantRow.unapply)
    }
  }


  def main(args: Array[String]) {
    val h2DB = "jdbc:h2:file:./data/plant-sim-load-test-db;MODE=MySQL;DATABASE_TO_UPPER=false;IFEXISTS=TRUE"
    val user = "sa"
    val pass = ""
    
    val db = Database.forConfig("h2mem1")
    try {
      // ...
    } finally db.close
    
    createTables()
    insertRows()
    
    println("START :: Inserting Records")
    buildImage(loadConfig("application.conf"))
  }
  
  def createTables() = {
  
  }
  
  def insertRows() = {
    insertOrganizations()
    insertPowerPlants()
    insertUsers()
  }

  def insertOrganizations() = {
    """
    |INSERT INTO `organization` VALUES 
    |  ('Organization-001', 'street-001', 'city-001', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    |  ('Organization-002', 'street-002', 'city-002', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    |  ('Organization-003', 'street-003', 'city-003', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    |  ('Organization-004', 'street-004', 'city-004', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());
    """.stripMargin
  }
  
  def insertPowerPlants() = {
    
  }
}

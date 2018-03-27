#!/bin/sh
exec scala "$0" "$@"
!#

/***
scalaVersion := "2.11.11"

libraryDependencies ++= Seq(
  "com.typesafe.play" %% "play-json-joda" % "2.6.0",
  "com.typesafe.slick" %% "slick" % "3.2.0",
  "com.h2database" % "h2" % "1.4.186"
)
*/

import java.io.File
import sys.process._

import slick.driver.H2Driver.api._
import scala.concurrent.ExecutionContext.Implicits.global
import driver.api._
import slick.jdbc.JdbcProfile

import org.joda.time.{DateTime, DateTimeZone}

/**
 * The goal of this file is to spit out a H2 database that
 * can be used to load test the plant-simulator application
 */
object DBGenerator {
  
  /**
   * ADT's defining the available PowerPlant Types
   */
  sealed trait PowerPlantType
  object PowerPlantType {
    case object OnOffType extends PowerPlantType
    case object RampUpType extends PowerPlantType
    case object UnknownType extends PowerPlantType

    def toString(powerPlantType: PowerPlantType): String = powerPlantType match {
      case OnOffType  => "OnOffType"
      case RampUpType => "RampUpType"
      case _          => "UnknownType"
    }

    def fromString(powerPlantTypeStr: String): PowerPlantType =
      powerPlantTypeStr match {
        case "OnOffType"  => OnOffType
        case "RampUpType" => RampUpType
        case _            => UnknownType
      }
  }
  
  class DBSchema (val driver: JdbcProfile) {

    import driver.api._
    
    // Slick table mappings
    case class OrganizationRow(
      orgName: String,
      street: String,
      city: String,
      country: String,
      createdAt: DateTime,
      updatedAt: DateTime
    )

    case class UserRow(
      userId: Int,
      orgName: String,
      firstName: String,
      lastName: String,
      createdAt: DateTime,
      updatedAt: DateTime
    )

    case class PowerPlantRow(
      id: Int,
      orgName: String,
      isActive: Boolean,
      minPower: Double,
      maxPower: Double,
      rampRatePower: Option[Double] = None,
      rampRateSecs: Option[Long] = None,
      powerPlantTyp: PowerPlantType,
      createdAt: DateTime,
      updatedAt: DateTime
    )

    /**
     * Mapping for using Joda Time and SQL Time.
     */
    implicit def dateTimeMapping =
      MappedColumnType.base[DateTime, java.sql.Timestamp](
        dt => new Timestamp(dt.getMillis),
        ts => new DateTime(ts.getTime, DateTimeZone.UTC)
      )

    /**
     * Mapping for using PowerPlantType conversions.
     */
    implicit def powerPlantTypeMapping =
      MappedColumnType.base[PowerPlantType, String](
        powerPlantType => PowerPlantType.toString(powerPlantType),
        powerPlantTypeStr => PowerPlantType.fromString(powerPlantTypeStr)
      )

    // Slick table mapping definitions
    class OrganizationTable(tag: Tag) extends Table[Organization](tag, "organization") {
      def orgName = column[String]("orgName", O.PrimaryKey)
      def street = column[String]("street")
      def city = column[String]("city")
      def country = column[String]("country")
      def createdAt = column[DateTime]("createdAt")
      def updatedAt = column[DateTime]("updatedAt")

      def * = {
        (orgName,
         street,
         city,
         country,
         createdAt,
         updatedAt) <>
          (OrganizationRow.tupled, OrganizationRow.unapply)
      }
    }

    class UserTable(tag: Tag) extends Table[User](tag, "user") {
      def id = column[Int]("userId", O.PrimaryKey)
      def orgName = column[String]("orgName")
      def firstName = column[String]("firstName")
      def lastName = column[String]("lastName")
      def createdAt = column[DateTime]("createdAt")
      def updatedAt = column[DateTime]("updatedAt")

      def * = {
        (id,
         orgName,
         firstName,
         lastName,
         createdAt,
         updatedAt) <>
          (UserRow.tupled, UserRow.unapply)
      }
    }

    class PowerPlantTable(tag: Tag) extends Table[PowerPlantRow](tag, "powerPlant") {
      def id = column[Int]("powerPlantId", O.PrimaryKey)
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
    
    val organizations = TableQuery[OrganizationTable]
    val users = TableQuery[UserTable]
    val powerPlants = TableQuery[PowerPlantTable]
  }

  // The main program starts here after all those ceremonies!
  def main(args: Array[String]) {
    val h2DB = "jdbc:h2:file:./data/plant-sim-load-test-db;MODE=MySQL;DATABASE_TO_UPPER=false;IFEXISTS=TRUE"
    val user = "sa"
    val pass = ""
    val driver: JdbcProfile = {
      Class.forName("org.h2.Driver")
      slick.jdbc.H2Profile 
    }
 
    val db: JdbcBackend.DatabaseDef = {
      Database.forURL(h2DB, user.orNull, pass.orNull, driver = driver)
    }
    
    // initialize the DBSchema
    val dbSchema: DBSchema = new DBSchema(driver)
    /* This shitty import should be here - Do not remove */
    import dbSchema._
    import dbSchema.driver.api._
    
    try {
      // 1. Drop if the schema exists
      h2SchemaDrop()
      
      // 2. Create the Schema
      h2SchemaSetup()
      
      // 3. Populate the tables
      populateTables()
    } finally db.close
  }
  
  protected def h2SchemaDrop(): Unit = {
    val allSchemas = DBIO.seq(
      (dbSchema.organizations.schema ++ dbSchema.users.schema ++ dbSchema.powerPlants.schema).create
    )
    Await.result(db.run(allSchemas), 5.seconds)
  }

  protected def h2SchemaSetup(): Unit = {
    val allSchemas = DBIO.seq(
      (dbSchema.organizations.schema ++ dbSchema.users.schema ++ dbSchema.powerPlants.schema).create
    )
    Await.result(db.run(allSchemas), 5.seconds)
  }
  
  // We create a sequence of Organization's
  val organizations = (1 to 4) map { i =>
    OrganizationRow(
      orgName = s"joesan $i",
      street = s"joesan street $i",
      city = s"joesan city $i",
      country = "GERMANY",
      createdAt = DateTime.now(DateTimeZone.UTC),
      updatedAt = DateTime.now(DateTimeZone.UTC)
    )
  }
  
  // We create a sequence of User's
  val users = (1 to 4) map { i =>
    UserRow(
      userId = i,
      orgName = s"joesan $i",
      firstName = s"joesan street $i",
      lastName = s"joesan city $i",
      createdAt = DateTime.now(DateTimeZone.UTC),
      updatedAt = DateTime.now(DateTimeZone.UTC)
    )
  }
  
  // We create a sequence of PowerPlant's
  val powerPlants = (1 to 100000) map { i =>
    PowerPlantRow(
      id = Some(i),
      orgName = if (i % 2 == 0) "joesan 1" else "joesan 2",
      isActive = true,
      minPower = if (i % 2 == 0) 200 else 100,
      maxPower = if (i % 2 == 0) 600 else 800,
      powerPlantTyp = if (i % 2 == 0) OnOffType else RampUpType,
      rampRatePower = if (i % 2 == 0) None else Some(20.0),
      rampRateSecs = if (i % 2 == 0) None else Some(2),
      createdAt = DateTime.now(DateTimeZone.UTC),
      updatedAt = DateTime.now(DateTimeZone.UTC)
    )
  }

  protected def populateTables(): Unit = {
    val setup = DBIO.seq(
      // Insert some Organization's
      dbSchema.organizations ++= organizations,
      
      // Insert some User's
      dbSchema.users ++ = users

      // Insert some PowerPlant's
      dbSchema.powerPlants ++= powerPlants
    )
    Await.result(testDatabase.run(setup), 5.seconds)
  }
}

#!/bin/sh
exec scala -classpath "lib/core_2.11-1.1.11.jar" "$0" "$@"
!#

import java.io.File
import sys.process._

import com.softwaremill.sttp._

import scala.concurrent.Await
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global

import com.softwaremill.sttp._

/**
 * The goal of this file is to send dispatches to a running plant-simulator
 * application via the REST endpoints exposed by the plant-simulator
 */
object Dispatcher {

  // Utility functions that we could use for dispatching
  def dispatchURL(id: Int) = s"http://localhost:9000/plantsim/powerplant/$id/dispatch"

  def onOffTypeDispatchPayload(id: Int) = {
    s"""
       |{
       |  "powerPlantId" : $id,
       |  "command" : "turnOn",
       |  "value" : true,
       |  "powerPlantType" : "OnOffType"
       |}
     """.stripMargin
  }

  def rampUpTypeDispatchPayload(id: Int) = {
    // We are safe to dispatch all RampUpType PowerPlants with at-least 400 kw
    s"""
       |{
       |  "powerPlantId" : $id,
       |  "command" : "dispatch",
       |  "value" : 400.0,
       |  "powerPlantType" : "RampUpType"
       |}
     """.stripMargin
  }

  def main(args: Array[String]) {
    (1 to 100000) map { i =>
      val url = dispatchURL(i)
      // All PowerPlants with even id is OnOffType and all odd ids are RampUpType
      if (i % 2 == 0) { // Dispatch OnOffType
        val request = sttp
          .body(onOffTypeDispatchPayload(i))
          .post(uri"http://localhost:9000/plantsim/powerplant/$i/dispatch")
        implicit val backend = HttpURLConnectionBackend()
        request.send()
      } else { // Dispatch RampUpType
        val request = sttp
          .body(rampUpTypeDispatchPayload(i))
          .post(uri"http://localhost:9000/plantsim/powerplant/$i/dispatch")
        implicit val backend = HttpURLConnectionBackend()
        request.send()
      }
    }
  }
}
Dispatcher.main(args)
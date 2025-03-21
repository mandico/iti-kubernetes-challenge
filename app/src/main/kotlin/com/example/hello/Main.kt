package com.example.hello

import io.ktor.server.application.*
import io.ktor.server.metrics.micrometer.*
import io.micrometer.prometheus.*
import io.ktor.server.routing.*
import io.ktor.server.response.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*

fun main() {
    val prometheusRegistry = PrometheusMeterRegistry(PrometheusConfig.DEFAULT)

    embeddedServer(Netty, port = 8080) {
        install(MicrometerMetrics) {
            registry = prometheusRegistry
        }

        routing {
            get("/") {
                call.respondText("Hello, World!")
            }

            get("/actuator/prometheus") {
                call.respondText(prometheusRegistry.scrape())
            }
        }
    }.start(wait = true)
}
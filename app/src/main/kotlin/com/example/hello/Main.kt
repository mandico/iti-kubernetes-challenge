package com.example.hello

import io.ktor.server.application.*
import io.ktor.server.metrics.micrometer.*
import io.micrometer.prometheus.*
import io.ktor.server.routing.*
import io.ktor.server.response.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*

fun main() {
    // Cria o registry do Prometheus
    val prometheusRegistry = PrometheusMeterRegistry(PrometheusConfig.DEFAULT)

    embeddedServer(Netty, port = 8080) {
        // Instala o Micrometer Metrics no Ktor
        install(MicrometerMetrics) {
            registry = prometheusRegistry
        }

        routing {
            // Endpoint principal
            get("/") {
                call.respondText("Hello, World!")
            }

            // Endpoint para expor métricas do Prometheus
            get("/actuator/prometheus") {
                call.respondText(prometheusRegistry.scrape())
            }
        }
    }.start(wait = true)
}
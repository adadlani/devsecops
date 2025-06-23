package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @RestController
    class LogController {
        private final Logger logger = LoggerFactory.getLogger(LogController.class);

        @GetMapping("/log")
        public String logSomething() {
            logger.info("This is an INFO log from Spring Boot backend!");
            logger.warn("This is a WARN log from Spring Boot backend!");
            logger.error("This is an ERROR log from Spring Boot backend!");
            return "Logs have been generated!";
        }
    }
}

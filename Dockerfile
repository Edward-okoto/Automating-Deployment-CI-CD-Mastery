FROM openjdk:11-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the Maven build into the container
COPY target/declarative-maven-project-1.0-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

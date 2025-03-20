pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('docker-hub-username') // Replace with Docker Hub credential ID
        DOCKERHUB_PASSWORD = credentials('docker-hub-password')
        DOCKER_IMAGE = 'edwardokoto1/jenkins-project:latest'
    }

    tools {
        maven 'maven 3' // Name of Maven installation in Jenkins Global Tool Configuration
        jdk 'java 11'  // Name of JDK installation in Jenkins Global Tool Configuration
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clones the repository
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Runs Maven build
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                // Runs Maven tests
                sh 'mvn test'
            }
        }

        stage('Archive Artifacts') {
            steps {
                // Archives JAR file for future use
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds the Docker image
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image') {
            steps {
                // Logs into Docker Hub and pushes the Docker image
                script {
                    sh """
                    echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                    docker push $DOCKER_IMAGE
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete!'
        }
        success {
            echo 'Build and Docker stages succeeded!'
        }
        failure {
            echo 'Build failed. Please check the logs for errors.'
        }
    }
}


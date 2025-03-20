pipeline {
    agent any

    tools {
        maven 'Maven 3' // Name of Maven installation in Jenkins Global Tool Configuration
        jdk 'Java 11'  // Name of JDK installation in Jenkins Global Tool Configuration
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
    }

    post {
        always {
            echo 'Pipeline execution complete!'
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}

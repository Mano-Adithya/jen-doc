pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build HTML1') {
            steps {
                dir('simple-html') {
                    script {
                        // Print Docker version for debugging
                        sh 'docker --version'
                        // Build Docker image for simple-html
                        sh 'docker build -t simple-html:latest .'
                    }
                }
            }
        }
        stage('Build HTML2') {
            steps {
                dir('new-html') {
                    script {
                        // Print Docker version for debugging
                        sh 'docker --version'
                        // Build Docker image for new-html
                        sh 'docker build -t new-html:latest .'
                    }
                }
            }
        }
        stage('Deploy HTML1') {
            steps {
                script {
                    // Deploy HTML1
                    echo 'Deploying HTML1'
                    // Add deployment commands here
                }
            }
        }
        stage('Deploy HTML2') {
            steps {
                script {
                    // Deploy HTML2
                    echo 'Deploying HTML2'
                    // Add deployment commands here
                }
            }
        }
    }
}

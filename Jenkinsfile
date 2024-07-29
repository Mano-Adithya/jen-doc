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
                        // Print Docker version for logging
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
                        // Print Docker version for logging
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
                    echo 'Deploying HTML1'
                    // Add your deployment commands for the simple-html Docker image
                }
            }
        }
        stage('Deploy HTML2') {
            steps {
                script {
                    echo 'Deploying HTML2'
                    // Add your deployment commands for the new-html Docker image
                }
            }
        }
    }
}

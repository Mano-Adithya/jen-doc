pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    // Check out the code from Git
                    checkout scm

                    // Build Docker image
                    sh 'sudo docker build -t simple-html:latest .'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Run Docker container
                    sh 'sudo docker run -d -p 80:80 simple-html:latest'
                }
            }
        }
    }
}

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    // Build Docker image
                    docker.build('simple-html:latest')
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Run Docker container
                    docker.image('simple-html:latest').run('-p 80:80')
                }
            }
        }
    }
}

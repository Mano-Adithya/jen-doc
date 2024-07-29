pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Mano-Adithya/jen-doc.git'
            }
        }
        
        stage('Build HTML1') {
            steps {
                dir('simple-html') {
                    script {
                        docker.build('simple-html:latest')
                    }
                }
            }
        }

        stage('Build HTML2') {
            steps {
                dir('new-html') {
                    script {
                        docker.build('another-html:latest')
                    }
                }
            }
        }

        stage('Deploy HTML1') {
            steps {
                script {
                    // Deploy simple-html container
                    docker.image('simple-html:latest').run('-d -p 8080:80')
                }
            }
        }

        stage('Deploy HTML2') {
            steps {
                script {
                    // Deploy another-html container
                    docker.image('another-html:latest').run('-d -p 8081:8081')
                }
            }
        }
    }
}

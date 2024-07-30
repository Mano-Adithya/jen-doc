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
                        sh 'docker build -t simple-html:latest .'
                    }
                }
            }
        }
        stage('Build HTML2') {
            steps {
                dir('new-html') {
                    script {
                        sh 'docker build -t new-html:latest .'
                    }
                }
            }
        }
        stage('Deploy HTML1') {
            steps {
                script {
                    sshagent(['jen-doc-ssh-key']) {  // Replace 'jen-doc-ssh-key' with your Jenkins SSH key credential ID
                        sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@13.233.153.214 "
                            docker pull simple-html:latest &&
                            docker stop simple_html || true &&
                            docker rm simple_html || true &&
                            docker run -d --name simple_html -p 8081:80 simple-html:latest
                        "
                        """
                    }
                }
            }
        }
        stage('Deploy HTML2') {
            steps {
                script {
                    sshagent(['jen-doc-ssh-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@13.233.153.214 "
                            docker pull new-html:latest &&
                            docker stop new_html || true &&
                            docker rm new_html || true &&
                            docker run -d --name new_html -p 8082:80 new-html:latest
                        "
                        """
                    }
                }
            }
        }
    }
}

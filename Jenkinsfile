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
                    sshagent(['jen-doc-ssh-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@3.110.196.20 "
                            docker pull simple-html:latest &&
                            docker ps -q --filter 'name=simple_html' | grep -q . && docker stop simple_html || true &&
                            docker ps -a -q --filter 'name=simple_html' | grep -q . && docker rm simple_html || true &&
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
                        ssh -o StrictHostKeyChecking=no ubuntu@3.110.196.20 "
                            docker pull new-html:latest &&
                            docker ps -q --filter 'name=new_html' | grep -q . && docker stop new_html || true &&
                            docker ps -a -q --filter 'name=new_html' | grep -q . && docker rm new_html || true &&
                            docker run -d --name new_html -p 8082:80 new-html:latest
                        "
                        """
                    }
                }
            }
        }
    }
}

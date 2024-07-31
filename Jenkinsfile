pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS_ID = 'jen-doc' // Jenkins credential ID for Docker Hub
        SSH_CREDENTIALS_ID = 'jen-doc-ssh-key' // Jenkins credential ID for SSH
        DOCKERHUB_REPO = 'manoadithyap/jen-doc-repo' // Replace with your Docker Hub username
        DEPLOY_SERVER = 'ubuntu@3.110.196.20' // Replace with your server IP
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build and Push HTML1') {
            steps {
                dir('simple-html') {
                    script {
                        sh 'docker build -t simple-html:latest .'
                        sh 'docker tag simple-html:latest $DOCKERHUB_REPO/simple-html:latest'
                        withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                            sh 'docker push $DOCKERHUB_REPO/simple-html:latest'
                        }
                    }
                }
            }
        }
        stage('Build and Push HTML2') {
            steps {
                dir('new-html') {
                    script {
                        sh 'docker build -t new-html:latest .'
                        sh 'docker tag new-html:latest $DOCKERHUB_REPO/new-html:latest'
                        withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                            sh 'docker push $DOCKERHUB_REPO/new-html:latest'
                        }
                    }
                }
            }
        }
        stage('Deploy HTML1') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS_ID]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                            docker pull $DOCKERHUB_REPO/simple-html:latest &&
                            docker stop simple_html || true &&
                            docker rm -f simple_html || true &&
                            docker run -d --name simple_html -p 8081:80 $DOCKERHUB_REPO/simple-html:latest
                        "
                        """
                    }
                }
            }
        }
        stage('Deploy HTML2') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS_ID]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                            docker pull $DOCKERHUB_REPO/new-html:latest &&
                            docker stop new_html || true &&
                            docker rm -f new_html || true &&
                            docker run -d --name new_html -p 8082:80 $DOCKERHUB_REPO/new-html:latest
                        "
                        """
                    }
                }
            }
        }
    }
}

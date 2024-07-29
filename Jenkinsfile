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
                        sh 'docker --version'
                        sh 'docker build -t simple-html:latest .'
                    }
                }
            }
        }
        stage('Build HTML2') {
            steps {
                dir('new-html') {
                    script {
                        sh 'docker --version'
                        sh 'docker build -t new-html:latest .'
                    }
                }
            }
        }
        stage('Deploy HTML1') {
            steps {
                script {
                    // SSH to EC2 instance and deploy the Docker image
                    sh """
                    ssh -i /path/to/your/private/key.pem ec2-user@your-ec2-ip-or-dns "
                        docker pull your-docker-repo/simple-html:latest &&
                        docker stop simple_html || true &&
                        docker rm simple_html || true &&
                        docker run -d --name simple_html -p 8080:80 simple-html:latest
                    "
                    """
                }
            }
        }
        stage('Deploy HTML2') {
            steps {
                script {
                    // SSH to EC2 instance and deploy the Docker image
                    sh """
                    ssh -i /path/to/your/private/key.pem ec2-user@your-ec2-ip-or-dns "
                        docker pull your-docker-repo/new-html:latest &&
                        docker stop new_html || true &&
                        docker rm new_html || true &&
                        docker run -d --name new_html -p 8081:80 new-html:latest
                    "
                    """
                }
            }
        }
    }
}

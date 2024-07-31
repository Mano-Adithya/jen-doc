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
        stage('Deploy') {
            steps {
                script {
                    sshagent(['jen-doc-ssh-key']) {  // Replace 'jen-doc-ssh-key' with your Jenkins SSH key credential ID
                        sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@3.110.196.20 "
                            # Remove existing containers if they exist
                            docker rm -f simple_html || true
                            docker rm -f new_html || true
                            docker rm -f nginx-proxy || true

                            # Run the new containers
                            docker run -d --name simple_html -p 8081:8081 simple-html:latest
                            docker run -d --name new_html -p 8082:8082 new-html:latest

                            # Run Nginx as a reverse proxy
                            docker run -d --name nginx-proxy -p 8081:80 \
                                -v /path/to/nginx.conf:/etc/nginx/nginx.conf:ro \
                                --link simple_html \
                                --link new_html \
                                nginx
                        "
                        '''
                    }
                }
            }
        }
    }
}

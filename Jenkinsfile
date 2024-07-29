pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-west-2'  // Replace with your desired region
        EC2_USER = 'ec2-user'     // Replace with your EC2 user
        EC2_IP = '18.170.117.56'
        DOCKER_REPO_NAME = 'to-do-list'
        BUILD_ID = '1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: '4', url: 'https://github.com/willie191998/to-do-app-with-docker-jerkins-amplify.git', branch: 'master'
            }
        }

        stage('Build and Push to Docker Hub') {
            steps {
                script {
                    def appImage = "${DOCKER_REPO_NAME}:${BUILD_ID}"

                    // Build the Docker images using docker-compose
                    sh 'docker-compose build'

                    // Log in to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials-id', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login --username \$DOCKER_USERNAME --password-stdin"
                    }

                    // Tag the image
                    sh "docker tag ${DOCKER_REPO_NAME}_app:${BUILD_ID} \$DOCKER_USERNAME/${appImage}"

                    // Push the image to Docker Hub
                    sh "docker push \$DOCKER_USERNAME/${appImage}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo 'Deploying docker image to EC2'
                    def dockerCmd = "docker run -p 8080:8080 -d \$DOCKER_USERNAME/${DOCKER_REPO_NAME}:${BUILD_ID}"

                    sshagent(['5']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                            cd /path/to/your/docker-compose/directory && \
                            docker-compose pull && \
                            docker-compose down && \
                            docker-compose up -d
                            '
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -a --force'
        }
    }
}

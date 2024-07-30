pipeline {
    agent any

    //pLEASE MODIFY THIS
    environment {
        DOCKER_USERNAME = 'wiley19'
        AWS_REGION = 'eu-west-2'  // Replace with your desired region
        EC2_USER = 'ec2-user'     // Replace with your EC2 user
        EC2_IP = '18.170.117.56'
        DOCKER_IMAGE_NAME = 'to-do-list'
        DOCKER_IMAGE_TAG = '1'
        SOURCE_IMAGE_NAME = 'node:14.15.0-alpine' // or the image you are pulling
    }

    options {
        timeout(time: 4, unit: 'MINUTES')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: '4', url: 'https://github.com/willie191998/to-do-app-with-docker-jerkins-amplify.git', branch: 'master'
                echo "Cloning Repo..."
            }
        }

        stage('Check Docker Version') {
            steps {
                sh 'docker --version'
                sh 'docker-compose --version'
                echo "TEsting docker setup"
            }
        }

        stage('Build and Push to Docker Hub') {
            steps {
                script {
                    
                    def fullImageName = "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    
                    // Pull the existing image from Docker Hub
                    sh "docker pull ${SOURCE_IMAGE_NAME}"

                    // List files to check if the directory is correct
                    sh "ls"
                    
                    // Build the Docker images using docker-compose
                    sh "docker-compose build"
                    
                    // Build Docker images
                    echo "Building Docker images..."

                    // Log in to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh """
                            echo \$DOCKER_PASSWORD | docker login --username \$DOCKER_USERNAME --password-stdin
                        """
                    }
                    
                    // Tag the existing image
                    sh "docker tag ${SOURCE_IMAGE_NAME} ${fullImageName}"

                    // Push the image to Docker Hub
                    sh "docker push ${fullImageName}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo 'Deploying Docker image to EC2'
                    def fullImageName = "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"

                    sshagent(['5']) { // Replace with your Jenkins SSH credentials ID
                        // Stop and remove any running containers, delete the existing docker-compose file,
                        // copy the new docker-compose file, and start the new containers.
                        sh """
                            scp -o StrictHostKeyChecking=no docker-compose.yml ${EC2_USER}@${EC2_IP}:/path/to/your/docker-compose/
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP}'
                            cd ./ && \
                            docker-compose down && \
                            rm docker-compose.yml && \
                            docker stop $(docker ps -q)
                            mv /path/to/your/docker-compose/docker-compose.yml . && \
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

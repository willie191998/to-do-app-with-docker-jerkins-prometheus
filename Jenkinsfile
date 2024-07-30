pipeline {
    agent any

    //pLEASE MODIFY THIS
    environment {
        DOCKER_USERNAME = 'wiley19'
        AWS_REGION = 'eu-west-2'  // Replace with your desired region
        EC2_USER = 'ec2-user'     // Replace with your EC2 user
        EC2_IP = '18.170.117.56'
        DOCKER_IMAGE_NAME = 'to-do-list'
        DOCKER_IMAGE_TAG = 'latest'
        SOURCE_IMAGE_NAME = 'node:14.15.0' // or the image you are pulling
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
                echo "Testing docker setup"
            }
        }

        stage('Build and Push to Docker Hub') {
            steps {
                script {
                    
                    def fullImageName = "${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    
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
                        sshagent(['5']) {
                        
                        // Connect to the EC2 instance and execute commands
                        sh '''
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} << 'EOF'
                            # Create the directory if it doesn't exist
                            if [ -d /docker ]; then
                                if [ "$(ls -A /docker)" ]; then
                                    rm -r /docker/*
                                else
                                    echo "Directory /docker is empty, nothing to remove"
                                fi
                            else
                                echo "Directory /docker does not exist"
                                mkdir -p /docker/ && \
                            fi
                        '''
                        
                        sh '''
                            # Copy the new docker-compose.yml file to the EC2 instance
                            scp -o StrictHostKeyChecking=no -r app docs docker-compose.yml Dockerfile yarn.lock package.json ${EC2_USER}@${EC2_IP}:/docker/
                            # Connect to the EC2 instance and execute commands
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} << 'EOF'
                            cd ./docker && \
                            # Check if there are running containers, stop and remove them if there are any
                            if [ $(docker ps -q) ]; then
                                docker stop $(docker ps -q) && \
                                docker rm $(docker ps -aq)
                            fi
                            # Synchronize files and directories using rsync
                            #rsync -av --exclude='.git' --exclude='node_modules' --exclude='*.log' --ignore-existing /docker/ ./ && \
                            # Remove the existing contents of the directory
                            #rm -rf ./* && \
                            # Move the new docker-compose.yml to the current directory
                            #mv /docker/* . && \
                            # Start the new containers
                            docker-compose up -d
                        '''
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

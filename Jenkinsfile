pipeline {
    agent any
    environment {
        DOCKER_CRED = credentials('wiley19')
        AWS_REGION = 'eu-west-2'  // Replace with your desired region
        ECR_REPO_NAME = 'todo-app'
        APP_RUNNER_SERVICE_NAME = 'to-do-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: '2', url: 'https://github.com/willie191998/to-do-app-with-docker-jerkins-amplify', branch: 'master'
            }
        }

        stage('Build image') {
            steps {
                sh 'docker build -t ${ECR_REPO_NAME}:${BUILD_ID} .'
                sh 'docker images'
            }
        }

        stage('Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '1']]) {
                    script {
                        // Get the login command from ECR
                        def ecrLogin = sh(script: "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com", returnStdout: true).trim()
                        sh ecrLogin

                        // Tag and push the image to ECR
                        sh "docker tag ${ECR_REPO_NAME}:${BUILD_ID} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${BUILD_ID}"
                        sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${BUILD_ID}"
                    }
                }
            }
        }

        stage('Deploy to App Runner') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '1']]) {
                    script {
                        // Create or update App Runner service
                        def appRunnerConfig = """
                        {
                            "ServiceName": "${APP_RUNNER_SERVICE_NAME}",
                            "SourceConfiguration": {
                                "ImageRepository": {
                                    "ImageIdentifier": "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${BUILD_ID}",
                                    "ImageConfiguration": {
                                        "Port": "80"
                                    },
                                    "ImageRepositoryType": "ECR"
                                },
                                "AutoDeploymentsEnabled": true
                            },
                            "InstanceConfiguration": {
                                "Cpu": "1024",
                                "Memory": "2048"
                            }
                        }
                        """
                        sh "echo '${appRunnerConfig}' > app-runner-config.json"
                        sh "aws apprunner create-service --cli-input-json file://app-runner-config.json || aws apprunner update-service --service-name ${APP_RUNNER_SERVICE_NAME} --source-configuration file://app-runner-config.json"
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
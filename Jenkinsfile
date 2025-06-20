pipeline {
    agent any

    environment {
        S3_BUCKET = "jenkins-darwin-ai"
        AWS_REGION = "ap-south-1"
        APP_NAME = "MyCodeDeployApp"
        DEPLOY_GROUP = "MyDeploymentGroup"
    }

    stages {
        stage('Clone from GitHub') {
            steps {
                git 'https://github.com/MYSTYX7/darwix-ai-assessment.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }

        stage('Package Code') {
            steps {
                sh 'zip -r app.zip *'
            }
        }

        stage('Upload to S3') {
            steps {
                withAWS(region: "${AWS_REGION}", credentials: 'aws-credentials') {
                    s3Upload(file: 'app.zip', bucket: "${S3_BUCKET}", path: 'app.zip')
                }
            }
        }

        stage('Deploy using CodeDeploy') {
            steps {
                withAWS(region: "${AWS_REGION}", credentials: 'aws-credentials') {
                    codedeployDeployment(
                        applicationName: "${APP_NAME}",
                        deploymentGroupName: "${DEPLOY_GROUP}",
                        s3Bucket: "${S3_BUCKET}",
                        s3Key: 'app.zip',
                        deploymentConfig: 'CodeDeployDefault.OneAtATime'
                    )
                }
            }
        }
    }

    post {
        failure {
            echo 'Deployment Failed. Please check logs.'
        }
        success {
            echo 'Deployment Successful!'
        }
    }
}

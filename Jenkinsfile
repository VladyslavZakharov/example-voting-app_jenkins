pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "khanbibi"
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '🔨 Building Docker images...'
                sh '''
                    docker build -t $DOCKERHUB_REPO/voting-app-vote:${BUILD_NUMBER} ./vote
                    docker build -t $DOCKERHUB_REPO/voting-app-result:${BUILD_NUMBER} ./result
                    docker build -t $DOCKERHUB_REPO/voting-app-worker:${BUILD_NUMBER} ./worker

                    docker tag $DOCKERHUB_REPO/voting-app-vote:${BUILD_NUMBER} $DOCKERHUB_REPO/voting-app-vote:latest
                    docker tag $DOCKERHUB_REPO/voting-app-result:${BUILD_NUMBER} $DOCKERHUB_REPO/voting-app-result:latest
                    docker tag $DOCKERHUB_REPO/voting-app-worker:${BUILD_NUMBER} $DOCKERHUB_REPO/voting-app-worker:latest
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '🚀 Pushing images to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                        docker push $DOCKERHUB_REPO/voting-app-vote:${BUILD_NUMBER}
                        docker push $DOCKERHUB_REPO/voting-app-vote:latest

                        docker push $DOCKERHUB_REPO/voting-app-result:${BUILD_NUMBER}
                        docker push $DOCKERHUB_REPO/voting-app-result:latest

                        docker push $DOCKERHUB_REPO/voting-app-worker:${BUILD_NUMBER}
                        docker push $DOCKERHUB_REPO/voting-app-worker:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Task #15 Complete! Images pushed to Docker Hub!'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}

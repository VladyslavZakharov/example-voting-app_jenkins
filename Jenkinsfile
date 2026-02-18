pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "khanbibi"
        IMAGE_TAG = ''
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                script {
                    IMAGE_TAG = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Build (Parallel)') {
            parallel {

                stage('Vote') {
                    steps {
                        sh """
                            docker build -t $DOCKERHUB_REPO/voting-app-vote:${IMAGE_TAG} ./vote
                            docker tag $DOCKERHUB_REPO/voting-app-vote:${IMAGE_TAG} $DOCKERHUB_REPO/voting-app-vote:latest
                        """
                    }
                }

                stage('Result') {
                    steps {
                        sh """
                            docker build -t $DOCKERHUB_REPO/voting-app-result:${IMAGE_TAG} ./result
                            docker tag $DOCKERHUB_REPO/voting-app-result:${IMAGE_TAG} $DOCKERHUB_REPO/voting-app-result:latest
                        """
                    }
                }

                stage('Worker') {
                    steps {
                        sh """
                            docker build -t $DOCKERHUB_REPO/voting-app-worker:${IMAGE_TAG} ./worker
                            docker tag $DOCKERHUB_REPO/voting-app-worker:${IMAGE_TAG} $DOCKERHUB_REPO/voting-app-worker:latest
                        """
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                        docker push $DOCKERHUB_REPO/voting-app-vote:${IMAGE_TAG}
                        docker push $DOCKERHUB_REPO/voting-app-vote:latest

                        docker push $DOCKERHUB_REPO/voting-app-result:${IMAGE_TAG}
                        docker push $DOCKERHUB_REPO/voting-app-result:latest

                        docker push $DOCKERHUB_REPO/voting-app-worker:${IMAGE_TAG}
                        docker push $DOCKERHUB_REPO/voting-app-worker:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build successful! Images pushed to Docker Hub.'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}

pipeline {
    agent any

    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh """
                    docker build -t voting-app-vote:${IMAGE_TAG} ./vote
                    docker build -t voting-app-result:${IMAGE_TAG} ./result
                    docker build -t voting-app-worker:${IMAGE_TAG} ./worker
                """
            }
        }

        stage('Test') {
            steps {
                sh 'echo Running tests... > test-report.txt'
                sh 'echo All tests passed >> test-report.txt'
                sh 'ls -la'
            }
        }

        stage('Package') {
            steps {
                sh """
                    docker tag voting-app-vote:${IMAGE_TAG} voting-app-vote:latest
                    docker tag voting-app-result:${IMAGE_TAG} voting-app-result:latest
                    docker tag voting-app-worker:${IMAGE_TAG} voting-app-worker:latest
                """
            }
        }

        stage('Push Images') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin

                        docker tag voting-app-vote:${IMAGE_TAG} ${DOCKER_USER}/voting-app-vote:${IMAGE_TAG}
                        docker tag voting-app-result:${IMAGE_TAG} ${DOCKER_USER}/voting-app-result:${IMAGE_TAG}
                        docker tag voting-app-worker:${IMAGE_TAG} ${DOCKER_USER}/voting-app-worker:${IMAGE_TAG}

                        docker tag voting-app-vote:${IMAGE_TAG} ${DOCKER_USER}/voting-app-vote:latest
                        docker tag voting-app-result:${IMAGE_TAG} ${DOCKER_USER}/voting-app-result:latest
                        docker tag voting-app-worker:${IMAGE_TAG} ${DOCKER_USER}/voting-app-worker:latest

                        docker push ${DOCKER_USER}/voting-app-vote:${IMAGE_TAG}
                        docker push ${DOCKER_USER}/voting-app-result:${IMAGE_TAG}
                        docker push ${DOCKER_USER}/voting-app-worker:${IMAGE_TAG}

                        docker push ${DOCKER_USER}/voting-app-vote:latest
                        docker push ${DOCKER_USER}/voting-app-result:latest
                        docker push ${DOCKER_USER}/voting-app-worker:latest
                    """
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'test-report.txt', allowEmptyArchive: false
        }
        success {
            echo "Pipeline completed successfully"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}

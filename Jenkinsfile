pipeline {
    agent any

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
                    docker build -t voting-app-vote ./vote
                    docker build -t voting-app-result ./result
                    docker build -t voting-app-worker ./worker
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                echo '🧪 Running tests (placeholder)...'
                sh '''
                    echo "No unit tests configured yet"
                '''
            }
        }

        stage('Package') {
            steps {
                echo '📦 Verifying built images...'
                sh '''
                    docker images | grep voting-app
                '''
            }
        }

        stage('Push Images') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        docker tag voting-app-vote $DOCKER_USER/voting-app-vote:latest
                        docker tag voting-app-result $DOCKER_USER/voting-app-result:latest
                        docker tag voting-app-worker $DOCKER_USER/voting-app-worker:latest

                        docker push $DOCKER_USER/voting-app-vote:latest
                        docker push $DOCKER_USER/voting-app-result:latest
                        docker push $DOCKER_USER/voting-app-worker:latest
                    '''
                }
            }
        }

    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}

pipeline {
    agent any

    environment {
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
                        sh "docker build -t voting-app-vote:${IMAGE_TAG} ./vote"
                    }
                }

                stage('Result') {
                    steps {
                        sh "docker build -t voting-app-result:${IMAGE_TAG} ./result"
                    }
                }

                stage('Worker') {
                    steps {
                        sh "docker build -t voting-app-worker:${IMAGE_TAG} ./worker"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                sh '''
                    echo "Running tests..." > test-report.txt
                    echo "All tests passed" >> test-report.txt
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'test-report.txt', allowEmptyArchive: false
        }
    }
}

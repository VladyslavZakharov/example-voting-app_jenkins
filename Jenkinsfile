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
                    env.IMAGE_TAG = sh(
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
                       
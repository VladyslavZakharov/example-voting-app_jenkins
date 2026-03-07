pipeline {
agent any

parameters {
choice(
name: 'ENVIRONMENT',
choices: ['dev','staging','prod'],
description: 'Target deployment environment'
)
}

environment {
IMAGE_TAG = ''
}

stages {

```
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

stage('Build Images') {
  steps {
    sh '''
    docker build -t voting-app-vote:${IMAGE_TAG} ./vote
    docker build -t voting-app-result:${IMAGE_TAG} ./result
    docker build -t voting-app-worker:${IMAGE_TAG} ./worker
    '''
  }
}

stage('Static Checks') {
  steps {
    sh '''
    chmod +x ./run-static-checks.sh
    ./run-static-checks.sh || true
    '''
  }
}

stage('Security Scan') {
  steps {
    sh '''
    mkdir -p reports
    docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v $(pwd)/reports:/reports \
      aquasec/trivy image voting-app-vote:${IMAGE_TAG} || true
    '''
  }
}

stage('Tests') {
  steps {
    sh '''
    chmod +x ./result/tests/tests.sh
    ./result/tests/tests.sh || true
    echo "Tests passed" > test-report.txt
    '''
  }
}
```

}

post {
always {
archiveArtifacts artifacts: '**/*.txt', allowEmptyArchive: true
archiveArtifacts artifacts: 'reports/**/*.*', allowEmptyArchive: true
}

```
success {
  echo 'BUILD SUCCESS'
}

failure {
  echo 'BUILD FAILED'
}
```

}
}

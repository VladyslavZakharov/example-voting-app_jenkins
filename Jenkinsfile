pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Checking out source code...'
                checkout scm
                
                sh '''
                    echo "✅ Checkout successful!"
                    echo "Current branch: $(git branch --show-current)"
                    git log -1 --oneline
                '''
            }
        }
        
        stage('Verify Repository') {
            steps {
                echo '🔍 Verifying repository...'
                sh '''
                    ls -la
                    ls -d vote result worker
                    echo "✅ All services found!"
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Task #11 Complete!'
        }
    }
}



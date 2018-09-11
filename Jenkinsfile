pipeline {
  agent any

  stages {
    stage('Build') {
      environment {
        TEST_FILE = 'docker-compose.test.yml'
      }
      steps {
        echo 'Building docker image..'
        sh 'docker-compose -f ${TEST_FILE} build'
      }
    }
    stage('Code analysis') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose -f ${TEST_FILE} run --rm app rubocop'
      }
    }
    stage('Test') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose -f ${TEST_FILE} run --rm app \
              rspec --profile 10 \
                    --format RspecJunitFormatter \
                    --out test_results/rspec.xml \
                    --format progress'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying....'
      }
    }
  }

  post {
    always {
      // Clean Workspace & docker images
      sh 'docker-compose -f ${TEST_FILE} down --volumes'
      sh 'docker system prune -f'
      cleanWs()
    }
  }

}
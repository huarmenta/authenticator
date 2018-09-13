pipeline {
  agent any // Run pipeline on any available agent

  // Set global environment variables
  environment {
    // docker compose base test arguments
    TEST_FILE = 'docker-compose.test.yml'
  }

  // Start pipeline stages
  stages {
    stage('Build docker image') {
      steps {
        echo 'Building docker image..'
        sh 'docker-compose -f ${TEST_FILE} build'
      }
    }
    stage('Rubocop') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose -f ${TEST_FILE} run --rm app rubocop'
      }
    }
    stage('RSpec') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose -f ${TEST_FILE} run --rm app rspec'
      }
    }
    stage('Deploy to gemstash server') {
      when { branch 'master' }
      steps {
        echo 'Deploying....'
        // build gem and deploy it to private gem server
        sh 'docker-compose -f ${TEST_FILE} run --rm app \
              gem build ${COMPOSE_PROJECT_NAME} && \
              gem push --key gemstash --host ${GEMSTASH_URL}/private \
              `ls -Art pkg/ | tail -n 1`' // find last built gem file
      }
    }
  }

  post {
    always {
      // remove docker containers & clean Jenkins workspace
      sh 'docker-compose -f ${TEST_FILE} down --volumes'
      // sh 'docker system prune -f'
      cleanWs()
    }
  }

}
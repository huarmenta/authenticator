pipeline {
  agent any // Run pipeline on any available agent

  // Set global environment variables
  environment {
    // docker compose base test arguments
    COMPOSE_TEST = '--file docker-compose.test.yml --project-name ${JOB_NAME}'
  }

  // Start pipeline stages
  stages {
    stage('Build docker image') {
      steps {
        echo 'Building docker image..'
        sh 'env'
        sh 'docker-compose ${COMPOSE_TEST} up --build --detach'
      }
    }
    stage('Rubocop') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose ${COMPOSE_TEST} exec app rubocop'
      }
    }
    stage('RSpec') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose -${COMPOSE_TEST} exec app rspec'
      }
    }
    stage('Deploy to gemstash server') {
      when { branch 'master' }
      steps {
        echo 'Deploying....'
        // build gem before deploy it to private gem server
        sh 'docker-compose ${COMPOSE_TEST} exec app gem build ${JOB_NAME}'
        // deploy built gem to private gem server
        sh 'docker-compose ${COMPOSE_TEST} exec app \
              gem push --key gemstash --host ${GEMSTASH_URL}/private \
              `ls -Art pkg/ | tail -n 1`' // find last built gem file
      }
    }
  }

  post {
    always {
      // remove docker containers & clean Jenkins workspace
      sh 'docker-compose ${COMPOSE_TEST} down --volumes'
      sh 'docker system prune -f'
      cleanWs()
    }
  }

}
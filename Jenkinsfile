pipeline {
  agent any // Run pipeline on any available agent

  // Set global environment variables
  environment {
    RAILS_ENV = 'test'
  }
  // Start pipeline stages
  stages {
    stage('Build docker image') {
      steps {
        echo 'Building docker image..'
        sh 'docker-compose build --build-arg UID=$(id -u)'
      }
    }
    stage('Rubocop') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose run --rm app rubocop'
      }
    }
    stage('RSpec') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose run --rm app rspec'
      }
    }
    stage('Deploy to gemstash server') {
      when { branch 'master' }
      steps {
        echo 'Deploying....'
        // build gem and deploy it to private gem server
        sh 'docker-compose run --rm app \
              gem build authenticator && \
              gem push --key gemstash --host ${GEMSTASH_URL}/private \
              `find ./ -name "*.gem" | sort | tail -1`' // last built gem file
      }
    }
  }

  post {
    always {
      // remove docker containers & clean Jenkins workspace
      sh 'docker-compose down --volumes'
      // sh 'docker system prune -f'
      cleanWs()
    }
  }

}
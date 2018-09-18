pipeline {
  agent any // Run pipeline on any available agent

  // Set global environment variables

  // Start pipeline stages
  stages {
    stage('Build docker image') {
      steps {
        echo 'Building docker image..'
        sh 'docker-compose up --build -d'
      }
    }
    stage('Rubocop') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose exec app rubocop'
      }
    }
    stage('RSpec') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose exec app rspec'
      }
    }
    // stage('Deploy to gemstash server') {
    //   when { branch 'master' }
    //   steps {
    //     echo 'Deploying....'
    //     // build gem and deploy it to private gem server
    //     sh 'docker-compose exec app \
    //           gem build authenticator && \
    //           gem push --key gemstash --host ${GEMSTASH_URL}/private \
    //           `find ./ -name "*.gem" | sort | tail -1`' // last built gem file
    //   }
    // }
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
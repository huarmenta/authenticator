pipeline {
  agent any // Run pipeline on any available agent

  // Set global environment variables
  environment {
    RAILS_ENV = 'test'
    REPORTS_DIR = 'test-reports'
  }
  // Start pipeline stages
  stages {
    stage('Build docker image') {
      steps {
        echo 'Building docker image..'
        // build with host user id
        sh 'docker-compose build --build-arg UID=$(id -u)'
      }
    }
    stage('Rubocop') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose run --rm app rubocop --format progress'
      }
    }
    stage('RSpec') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose run --rm app rspec --profile 10 \
              --format RspecJunitFormatter \
              --out ${REPORTS_DIR}/rspec.xml \
              --format progress'
      }
    }
    // stage('Deploy to gemstash server') {
    //   when { branch 'master' }
    //   steps {
    //     echo 'Deploying....'
    //     // build gem and deploy it to private gem server
    //     sh 'docker-compose run --rm app \
    //           gem build authenticator && \
    //           gem push --key gemstash --host ${GEMSTASH_URL}/private \
    //           `find ./ -name "*.gem" | sort | tail -1`' // last built gem file
    //   }
    // }
  }

  post {
    always {
      // collect junit test results
      junit "**/${REPORTS_DIR}/*.xml"
      // publish simplecov html report
      publishHTML (target: [
        allowMissing: false,
        alwaysLinkToLastBuild: false,
        keepAll: true,
        reportDir: 'coverage',
        reportFiles: 'index.html',
        reportName: 'RCov report',
        reportTitles: 'Simplecov report'
      ])
      // remove docker containers
      sh 'docker-compose down --volumes'
      sh 'docker system prune -f'
      // clean Jenkins workspace
      cleanWs()
    }
  }

}
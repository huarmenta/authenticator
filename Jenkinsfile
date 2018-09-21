pipeline {
  agent any // Run pipeline on any available agent

  // Set global environment variables
  environment {
    APP_NAME = 'authenticator'
    RAILS_ENV = 'test'
    REPORTS_DIR = 'test-reports'
    BUNDLE_WITHOUT = 'production'
  }
  // Start pipeline stages
  stages {
    stage('Build docker image') {
      steps {
        echo 'Building docker image..'
        // build with host user id
        sh 'docker-compose build \
              --build-arg UID=$(id -u) \
              --build-arg RAILS_ENV=${RAILS_ENV} \
              --build-arg BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
              --build-arg GEMSTASH_PUSH_KEY=${GEMSTASH_PUSH_KEY}'
      }
    }
    stage('Rubocop') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose run --rm app rubocop \
              --format html \
              --out rubocop/index.html \
              --format progress'
      }
    }
    stage('RSpec') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose run --rm app rspec \
              --profile 10 \
              --format RspecJunitFormatter \
              --out ${REPORTS_DIR}/junit/rspec.xml \
              --format progress'
      }
    }
    stage('Deploy to gemstash server') {
      when { branch 'master' }
      steps {
        echo 'Deploying....'
        // build gem and deploy it to private gem server
        sh 'docker-compose run --rm app gem build ${APP_NAME}'
        // load gemstash private server key & push gem to private server
        sh 'docker-compose run --rm app gem push \
              --key gemstash \
              --host ${GEMSTASH_URL}/private \
              `find ./ -name "*.gem" | sort | tail -1`' // last built gem file
      }
    }
  }
  // Post build stages actions
  post {
    always {
      // publish rubocop html report results
      publishHTML (target: [
        allowMissing: false,
        alwaysLinkToLastBuild: false,
        keepAll: true,
        reportDir: 'rubocop',
        reportFiles: 'index.html',
        reportName: 'Linter report',
        reportTitles: 'Rubocop report'
      ])
      // collect junit test results
      junit "**/${REPORTS_DIR}/junit/*.xml"
      // publish simplecov html report results
      publishHTML (target: [
        allowMissing: false,
        alwaysLinkToLastBuild: false,
        keepAll: true,
        reportDir: 'coverage',
        reportFiles: 'index.html',
        reportName: 'SimpleCov report',
        reportTitles: 'SimpleCov report'
      ])
      // remove docker containers and its volumes
      sh 'docker-compose down --volumes'
      // clean Jenkins workspace
      cleanWs()
    }
  }

}

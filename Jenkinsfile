pipeline {
  agent any // Run pipeline on any available agent

  // Start pipeline stages
  stages {
    stage('Build docker test image') {
      environment {
        RAILS_ENV = 'test'
      }
      steps {
        echo 'Building docker image..'
        // build with host user id
        sh 'docker-compose build \
              --build-arg UID=$(id -u) \
              --build-arg RAILS_ENV=${RAILS_ENV}'
      }
    }
    stage('Rubocop') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose run --rm app bundle exec rubocop \
              --format html \
              --out rubocop/index.html \
              --format fuubar'
      }
    }
    stage('RSpec') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose run --rm app bundle exec rspec \
              --profile 10 \
              --format RspecJunitFormatter \
              --out ${REPORTS_DIR}/junit/rspec.xml \
              --format Fuubar'
      }
    }
    stage('Deploy to gemstash server') {
      when { branch 'master' }
      environment {
        GEMSTASH_URL = credentials('gemstash-url')
        GEMSTASH_PUSH_KEY = credentials('gemstash-push-key')
      }
      steps {
        echo 'Deploying....'
        // build gem and deploy it to private gem server
        sh 'docker-compose run \
            -e GEMSTASH_URL=${GEMSTASH_URL} \
            -e GEMSTASH_PUSH_KEY=${GEMSTASH_PUSH_KEY} \
            --rm app ./deploy-gem.sh'
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
        reportName: 'Code coverage report',
        reportTitles: 'SimpleCov report'
      ])
      // remove docker containers and its volumes
      sh 'docker-compose down --volumes'
      // clean Jenkins workspace
      cleanWs()
    }
  }

}

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo 'Building docker image..'
        sh 'docker-compose up --build -d'
      }
    }
    stage('Code analysis') {
      steps {
        echo 'Running code analysis..'
        sh 'docker-compose exec app rubocop'
      }
    }
    stage('Test') {
      steps {
        echo 'Running unit tests..'
        sh 'docker-compose exec app rspec --profile 10 \
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
}
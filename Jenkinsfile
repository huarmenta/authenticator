pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo 'Building docker image..'
        docker-compose up --build -d
      }
    }
    stage('Code analysis') {
      steps {
        echo 'Running code analysis..'
        docker-compose exec app rubocop
      }
    }
    stage('Test') {
      steps {
        echo 'Running unit tests..'
        docker-compose exec app rspec --profile 10 \
                                  --format RspecJunitFormatter \
                                  --out test_results/rspec.xml \
                                  --format progress
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying....'
      }
    }
  }
}
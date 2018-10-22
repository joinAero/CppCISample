// Using a Jenkinsfile: https://jenkins.io/doc/book/pipeline/jenkinsfile/
pipeline {
  agent {
    docker { image 'ubuntu:xenial' }
  }

  environment {
    MY_BUILD_TYPE = 'Release'
    MY_INSTALL_PREFIX = '/usr/local'
  }

  stages {
    stage('Init') {
      steps {
        echo 'Initing..'
        sh '''
        apt-get update
        apt-get install -y build-essential pkg-config make cmake git
        apt-get install -y libglfw3-dev libglew-dev
        '''
      }
    }
    stage('Clone') {
      steps {
        echo 'Cloning..'
        sh '''
        cd /usr/src/
        git clone --recurse https://github.com/joinAero/CppCISample.git
        '''
      }
    }
    stage('Prepare') {
      steps {
        echo 'Preparing..'
        sh '''
        cd /usr/src/CppCISample/
        mkdir -p _build && cd _build/
        cmake -DCMAKE_BUILD_TYPE=$MY_BUILD_TYPE \
        -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_PREFIX \
        ..
        '''
      }
    }
    stage('Build') {
      steps {
        echo 'Building..'
        sh 'cd /usr/src/CppCISample/_build/; make'
      }
    }
    stage('Test') {
      steps {
        echo 'Testing..'
      }
    }
    stage('Install') {
      steps {
        echo 'Installing..'
        sh 'cd /usr/src/CppCISample/_build/; make install'
      }
    }
  }

  post {
    always {
      echo 'This will always run'
    }
    success {
      echo 'This will run only if successful'
    }
    failure {
      echo 'This will run only if failed'
    }
    unstable {
      echo 'This will run only if the run was marked as unstable'
    }
    changed {
      echo 'This will run only if the state of the Pipeline has changed'
      echo 'For example, if the Pipeline was previously failing but is now successful'
    }
  }
}

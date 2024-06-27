pipeline {
  environment {
    imagename = "orsanaw/hello-app-development"
    registryCredential = 'dockerhub'
    dockerImage = ''
    awsAccessKeyId = 'key ID of aws credentials'
    awsSecretAccessKey = 'secret access key of aws credentials'
    s3BucketName = 'hello-app-helm-charts2'
  }
  agent any
  stages {
    stage('Building image') {
      steps {
        script {
          echo 'Building image'
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Deploy Image') {
      steps {
        script {
          echo 'Pushing image'
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
          }
        }
      }
    }
     stage('Package Helm Chart') {
      steps {
        script {
          def timestamp = sh(script: 'date +%Y-%m-%d_%H-%M-%S', returnStdout: true).trim()
          echo $timestamp
          def filename = "hello-app-${timestamp}.tgz"
          echo $filename
          sh 'helm package webapp/ -o $filename'
        }
      }
    }
  }
}

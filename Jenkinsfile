pipeline {
  environment {
    imagename = "orsanaw/hello-app"
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
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Deploy Image') {
      steps {
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
          }
        }
      }
    stage('Package Helm Chart') {
      steps {
        script {
          sh 'helm package webapp/'
        }
      }
    }
    stage('Upload Helm Chart to S3') {
      steps {
        script {
          // Install AWS CLI plugin
          sh 'helm plugin install https://github.com/hypnoglow/helm-s3.git'
          sh 'aws s3 push ./hello-app-1.0.0.tgz s3://${s3BucketName}/charts/'
        }
      }
    }
  }
}

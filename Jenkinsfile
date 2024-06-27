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
//     stage('Building image') {
//       steps {
//         script {
//           echo 'Building image'
//           dockerImage = docker.build imagename
//         }
//       }
//     }
//     stage('Deploy Image') {
//       steps {
//         script {
//           echo 'Pushing image'
//           docker.withRegistry( '', registryCredential ) {
//             dockerImage.push("$BUILD_NUMBER")
//           }
//         }
//       }
//     }
     stage('Package Helm Chart') {
      steps {
        script {
          def filename = "hello-app-${BUILD_NUMBER}.tgz"
          sh 'helm package webapp/'
          sh 'mv *.tgz $filename'
        }
      }
    }
  }
}

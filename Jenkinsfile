pipeline {
  environment {
    imagename = "orsanaw/hello-app-development"
    registryCredential = 'dockerhub'
    dockerImage = ''
    awsAccessKeyId = 'key ID of aws credentials'
    awsSecretAccessKey = 'secret access key of aws credentials'
    s3BucketName = 'hello-app-helm-charts2'
    helm-package-filename = ''
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
          helm-package-filename = "hello-app-${BUILD_NUMBER}.tgz"
          sh """
                helm package webapp/
                mv *.tgz ${helm-package-filename}
             """
        }
      }
    }
    stage('Push helm chart to S3 bucket') {
      steps {
          script {
              // Install AWS CLI plugin
              sh """
              helm plugin install https://github.com/hypnoglow/helm-s3.git
              aws s3 push ./${helm-package-filename} s3://${s3BucketName}/charts/
              """
            }
      }
    }
  }
}

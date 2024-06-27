pipeline {
  environment {
    imagename = "orsanaw/hello-app-development"
    registryCredential = 'dockerhub'
    dockerImage = ''
    awsAccessKeyId = 'key ID of aws credentials'
    awsSecretAccessKey = 'secret access key of aws credentials'
    s3BucketName = 'hello-app-helm-charts2'
    helmPackageFilename = ''
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
     stage('Install helm S3 plugin only if does not exist') {
       steps {
        script {
          sh '''
            export helm_s3_installed=$(helm plugin list | grep s3)
                if [ -z "${helm_s3_installed}" ]; then
                helm plugin install https://github.com/hypnoglow/helm-s3.git
                else
                echo "plugin helm-s3 is already installed"
                fi
            '''
          }
        }
     }
     stage('Package Helm Chart') {
      steps {
        script {
          helmPackageFilename = "hello-app-${BUILD_NUMBER}.tgz"
          sh """
                helm package webapp/
                mv *.tgz ${helmPackageFilename}
             """
        }
      }
    }
    stage('Push helm chart to S3 bucket') {
      steps {
          script {
              // Install AWS CLI plugin and push chart to s3 bucket
              sh """
              helm s3 push ./${helmPackageFilename} s3://${s3BucketName}/charts/
              """
            }
      }
    }
  }
}

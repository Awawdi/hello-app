pipeline {
  environment {
    imagename = "orsanaw/hello-app-development"
    registryCredential = 'dockerhub'
    dockerImage = ''
    s3BucketName = 'hello-app-helm-charts2'
    helmRepoName = 'hello-app-repo'
    helmPackageFilename = ''
  }

  agent any
  stages {
    stage('Building image') {
      steps {
        script {
          echo 'Building image'
          imagename = docker.build(imagename)
          echo "Built image: ${imageName}"
        }
      }
    }
    stage('Deploy Image') {
      steps {
        script {
          echo 'Pushing image'
          docker.withRegistry( '', registryCredential ) {
            docker.push("${imageName}:${BUILD_NUMBER}")
          }
        }
      }
    }
//      stage('Install helm S3 plugin only if does not exist') {
//        steps {
//         script {
//           sh '''
//             helm version --short
//             export helm_s3_installed=$(helm plugin list | grep s3)
//                 if [ -z "${helm_s3_installed}" ]; then
//                 helm plugin install https://github.com/hypnoglow/helm-s3.git
//                 else
//                 echo "plugin helm-s3 is already installed"
//                 fi
//             '''
//           }
//         }
//      }
//     stage('Initialize an S3 bucket as a Helm repository') {
//       steps {
//           withAWS(region: 'us-east-1', credentials: 'aws-credentials') {
//             script {
//               sh """
//               helm s3 init --ignore-if-exists s3://${s3BucketName}/stable/myapp
//               aws s3 ls s3://${s3BucketName}/stable/myapp/
//               helm repo add ${helmRepoName} s3://${s3BucketName}/stable/myapp/ --force-update
//               """
//           }
//         }
//       }
//     }
//     stage('Package Helm Chart') {
//       steps {
//         withAWS(region: 'us-east-1', credentials: 'aws-credentials') {
//           script {
//               sh """
//                     helm package ./webapp --version 1.1.${BUILD_NUMBER}
//                     helm s3 push ./hello-app-1.1.${BUILD_NUMBER}.tgz ${helmRepoName}
//                     helm search repo ${helmRepoName}
//                  """
//           }
//         }
//        }
//     }
}
}

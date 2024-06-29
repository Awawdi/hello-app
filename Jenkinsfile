pipeline {
  environment {
    HELM_APP_NAME = "hello-app"
    HELM_CHART_DIRECTORY = "webapp"

    IMAGENAME = "orsanaw/hello-app-development:${BUILD_NUMBER}"
    registryCredential = 'dockerhub'
    s3BucketName = 'hello-app-helm-charts2'
    helmRepoName = 'hello-app-repo'
  }

  agent any
  options {
        timeout(time: 1, unit: 'HOURS')
  stages {
    stage('Building image') {
      steps {
        script {
          echo 'Building image'
          docker.withRegistry('', registryCredential) {
            def ImageNameToPush = docker.build(IMAGENAME) // Capture the image name
            ImageNameToPush.push()
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
    //     stage('Package Helm Chart and push to repository') {
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
    stage('Deploy Image to k8s'){
            steps {
             script {
               sh '''
                helm list
                helm lint ./${HELM_CHART_DIRECTORY}
                helm upgrade --wait --timeout=1m --set image.tag=${BUILD_NUMBER} ${HELM_APP_NAME} ./${HELM_CHART_DIRECTORY}
                helm list | grep ${HELM_APP_NAME}
                '''
            }
        }
    }
  }
}
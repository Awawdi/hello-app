pipeline {
  agent any
  environment {
    PATH = "/usr/sbin:$PATH" // Ensure Helm binary path is included
    HELM_APP_NAME = "hello-app"
    HELM_CHART_DIRECTORY = "webapp"

    IMAGENAME = "orsanaw/hello-app-development:${BUILD_NUMBER}"
    registryCredential = 'dockerhub'
    S3BUCKETNAME = 'hello-app-helm-charts2'
    helmRepoName = 'hello-app-repo'
    KUBECONFIG_CONTENT = credentials('kubeconfig-credentials-id')

  }

  options {
    timeout(time: 1, unit: 'HOURS')
  }
  stages {
    stage('Building image') {
      steps {
        script {
          echo 'Building image'
          docker.withRegistry('', registryCredential) {
            def ImageName = docker.build(IMAGENAME) // Capture the image name
            ImageName.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi ${IMAGENAME}"
      }
    }
      stage('Install helm S3 plugin only if does not exist') {
        steps {
          script {
            def helmS3Installed = sh(script: 'helm plugin list | grep s3', returnStatus: true)
            if (helmS3Installed != 0) {
                sh 'helm plugin install https://github.com/hypnoglow/helm-s3.git'
            } else {
                echo "plugin helm-s3 is already installed"
            }
          }
        }
      }
      stage('Initialize an S3 bucket as a Helm repository') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-credentials') {
                    script {
                        sh """
                        helm s3 init --ignore-if-exists s3://${S3BUCKETNAME}/stable/myapp
                        aws s3 ls s3://${S3BUCKETNAME}/stable/myapp/
                        helm repo add ${helmRepoName} s3://${S3BUCKETNAME}/stable/myapp/ --force-update
                        helm package ./webapp --version 1.1.${BUILD_NUMBER}
                        helm s3 push ./hello-app-1.1.${BUILD_NUMBER}.tgz ${helmRepoName}
                        helm search repo ${helmRepoName}
                        """
                    }
                }
            }
        }
//       stage('Deploy using Helm') {
//         steps {
//           script {
//             // Write kubeconfig content to a temporary file
//             writeFile file: '/tmp/kubeconfig', text: KUBECONFIG_CONTENT
//             // Set secure permissions for kubeconfig file
//             sh 'chmod 600 /tmp/kubeconfig'
//
//             sh """
//             helm upgrade ${HELM_APP_NAME} ${helmRepoName}/${HELM_APP_NAME} \\
//                         --set appName=${HELM_APP_NAME} \\
//                         --set image.name=${IMAGENAME} \\
//                         --set image.tag=${BUILD_NUMBER} \\
//                         --install \\
//                         --force \\
//                         --wait
//             """
//             }}}
  }
}
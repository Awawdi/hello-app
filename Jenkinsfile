pipeline {
  agent any
  environment {
    PATH = "/usr/sbin:$PATH"  // Ensure Helm binary path is included
    HELM_APP_NAME = "hello-app"
    HELM_CHART_DIRECTORY = "webapp"

    IMAGENAME = "orsanaw/hello-app-development:${BUILD_NUMBER}"
    registryCredential = 'dockerhub'
    s3BucketName = 'hello-app-helm-charts2'
    helmRepoName = 'hello-app-repo'
    KUBECONFIG = credentials('kubeconfig-credentials-id')

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
            def ImageNameToPush = docker.build(IMAGENAME) // Capture the image name
            ImageNameToPush.push()
          }
        }
      }
    }

         stage('Install helm S3 plugin only if does not exist') {
           steps {
            script {
              sh '''
                helm version --short
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
        stage('Initialize an S3 bucket as a Helm repository') {
          steps {
              withAWS(region: 'us-east-1', credentials: 'aws-credentials') {
                script {
                  sh """
                  helm s3 init --ignore-if-exists s3://${s3BucketName}/stable/myapp
                  aws s3 ls s3://${s3BucketName}/stable/myapp/
                  helm repo add ${helmRepoName} s3://${s3BucketName}/stable/myapp/ --force-update
                  helm package ./webapp --version 1.1.${BUILD_NUMBER}
                  helm s3 push ./hello-app-1.1.${BUILD_NUMBER}.tgz ${helmRepoName}
                  helm search repo ${helmRepoName}
                     """
              }
            }
           }
        }
  stage('Deploy using Helm') {
            steps {
                script {
                    // Install Helm if not already installed
                    sh '''
                    if ! command -v helm &> /dev/null
                    then
                        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
                    fi
                    '''
                    // Save kubeconfig content to a temporary file
                    writeFile file: '/tmp/kubeconfig', text: env.KUBECONFIG
                    // Run Helm upgrade command
                    sh 'KUBECONFIG=/tmp/kubeconfig helm upgrade hello-app hello-app-repo/hello-app --set appName=hello-app --set image.name=orsanaw/hello-app-development:86 --set image.tag=86 --install --force --wait'
                }
            }
        }
  }
}
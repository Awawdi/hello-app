podTemplate(label: 'mypod', serviceAccount: 'jenkins-ci', containers: [
    containerTemplate(
      name: 'docker',
      image: 'docker',
      command: 'cat',
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'kubectl',
      image: 'amaceog/kubectl',
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi',
      ttyEnabled: true,
      command: 'cat'
    ),
    containerTemplate(
      name: 'helm',
      image: 'alpine/helm:2.14.0',
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi',
      ttyEnabled: true,
      command: 'cat'
    )
  ],

  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    hostPathVolume(mountPath: '/usr/local/bin/helm', hostPath: '/usr/local/bin/helm')
  ]
  ) {
    node('mypod') {
  environment {
    HELM_APP_NAME = "hello-app"
    HELM_CHART_DIRECTORY = "webapp"

    IMAGENAME = "orsanaw/hello-app-development:${BUILD_NUMBER}"
    registryCredential = 'dockerhub'
    s3BucketName = 'hello-app-helm-charts2'
    helmRepoName = 'hello-app-repo'
    KUBECONFIG_PATH = '/var/lib/jenkins/.config/config'
  }

  options {
        timeout(time: 1, unit: 'HOURS')
          }
//     stage('Building image') {
//       steps {
//         script {
//           echo 'Building image'
//           docker.withRegistry('', registryCredential) {
//             def ImageNameToPush = docker.build(IMAGENAME) // Capture the image name
//             ImageNameToPush.push()
//           }
//         }
//       }
//     }

         stage('Install helm S3 plugin only if does not exist') {
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

        stage('Initialize an S3 bucket as a Helm repository') {
             container('helm'){
                script {
                  sh """
                  helm s3 init --ignore-if-exists s3://${s3BucketName}/stable/myapp
                  aws s3 ls s3://${s3BucketName}/stable/myapp/
                  helm repo add ${helmRepoName} s3://${s3BucketName}/stable/myapp/ --force-update
                  helm package ./webapp --version 1.1.${BUILD_NUMBER}
                  helm s3 push ./hello-app-1.1.${BUILD_NUMBER}.tgz ${helmRepoName}
                  helm search repo ${helmRepoName}
                  helm upgrade --wait --timeout=1m --set image.tag=${BUILD_NUMBER} ${HELM_APP_NAME} ./${HELM_CHART_DIRECTORY}
                  helm list | grep ${HELM_APP_NAME}
                     """
              }
            }
           }
           }
}
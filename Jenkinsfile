pipeline {
  agent any
  environment {
    /* Tag image using Docker registry and build tag */
    IMAGE_NAME="127.0.0.1:5000/psc/acme-banking:${BUILD_TAG}"
    IMAGE_ALIAS="127.0.0.1:5000/psc/acme-banking:latest"
  }

  stages {
    /* Scan source code for secrets before we inject any dependencies */
    stage('Secret Management') {
      steps {
        sh '/bin/sh -x ${WORKSPACE}/bin/hawkeyesec.sh'
      }
    }

    /* Install dependencies -- node.js code does not require a real "buid" */
    stage('Build') {
      steps {
        sh 'npm install'
      }
    }

    /* ESlint is installed as a dependency, and thus must happen after build */
    stage('ESLint') {
      steps {
        sh 'npx eslint ${WORKSPACE}'
      }
    }

    /* Identify known vulnerable dependencies */
    //stage('Software Composition Analysis') {
    //  steps {
    //    sh 'snyk test'
    //    sh 'npm audit'
    //  }
    //}

    /* Sonarqube is not a full SAST solution but will pick up some vulnerabilities */
    //stage('Static Analysis') {
    //  steps {
    //    withCredentials([string(credentialsId: 'sonarqube_token', variable: 'sonarqube_token')]) {
    //      sh 'echo ${sonarqube_token}'
    //      sh '/opt/sonar-scanner-3.2.0.1227-linux/bin/sonar-scanner \
    //        -Dsonar.projectKey=acme-banking -Dsonar.sources=${WORKSPACE} \
    //        -Dsonar.host.url=http://devsecops.local:9000/ \
    //        -Dsonar.login=${sonarqube_token}'
    //    }
    //  }
    //}

     stage('Docker Image'){
       steps{
    //     withCredentials([string(credentialsId: 'AQUA_TOKEN', variable: 'AQUA_TOKEN')]) {
           sh '/bin/sh -x ${WORKSPACE}/bin/dockerimage.sh'
    //     }
       }
     }
     stage('Docker Clean-up'){
       steps{
         sh '/bin/sh -x ${WORKSPACE}/bin/dockercleanup.sh'
       }
     }
     stage ('Docker Deploy & Zap Scan'){
       steps{
        sh '/bin/sh -x ${WORKSPACE}/bin/zapscan.sh'
       }
     }
     stage ('DefectDojo'){
       steps{
        sh '/bin/sh -x ${WORKSPACE}/bin/dojo_upload.sh -f ${WORKSPACE}/reports/zap/${BUILD_TAG}.xml -t ace44a038703cd77f606ad2c5471ad8ab150117a -d 192.168.56.106 -s ZAP'
       }
     }
    // stage('Threadfix Result'){
    //   steps{
    //     withCredentials([string(credentialsId: 'THREADFIX_API_KEY', variable: 'THREADFIX_API_KEY')]) {
    //       sh '/bin/sh -x ${WORKSPACE}/bin/threadfix.sh'
    //     }
    //   }
    // }
  }
}


    // stage('Docker Image'){
    //   steps{
    //     withCredentials([string(credentialsId: 'AQUA_TOKEN', variable: 'AQUA_TOKEN')]) {
    //       sh '/bin/sh -x ${WORKSPACE}/bin/dockerimage.sh'
    //     }
    //   }
    // }
    // stage('Docker Clean-up'){
    //   steps{
    //     sh '/bin/sh -x ${WORKSPACE}/bin/dockercleanup.sh'
    //   }
    // }
    // stage ('Docker Deploy & Zap Scan'){
    //   steps{
    //     sh '/bin/sh -x ${WORKSPACE}/bin/zapscan.sh'
    //   }
    // }
    // stage('Threadfix Result'){
    //   steps{
    //     withCredentials([string(credentialsId: 'THREADFIX_API_KEY', variable: 'THREADFIX_API_KEY')]) {
    //       sh '/bin/sh -x ${WORKSPACE}/bin/threadfix.sh'
    //     }
    //   }
    // }
  }
}

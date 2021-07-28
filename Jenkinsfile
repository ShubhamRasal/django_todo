pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh 'make test'
                junit 'reports/*.xml'
            }
        }
        stage('build') {
            steps {
                sh 'make build'
            }
        }
        stage('publish') {
            steps {
                sh 'make publish'
            }
        }
        stage('deploy'){
            steps{
                sshagent(['bastion', 'server']) {
                          withCredentials([file(credentialsId: 'vault_password', variable: 'vault_pass')]) {
                              sh "make deploy vault_pass_file=${vault_pass}"
                        }
                }
            }
        }
    }
    post{
        always {
                sh 'make clean'
            }
    }
}
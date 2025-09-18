pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/my-company-org-95/Kubernetes_Project.git'
            }
        }

        stage('Sending Docker file to Ansible server over SSH') {
            steps {
                sshagent(['ansible-demo']) {
                    sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/Kubernetes_Project/* ubuntu@172.31.84.4:/home/ubuntu'
                }
            }
        }

        stage('Docker Build image') {
            steps {
                sshagent(['ansible-demo']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.84.4 "
                            cd /home/ubuntu && \\
                            docker build -t ${JOB_NAME}:v1.${BUILD_ID} .
                        "
                    '''
                }
            }
        }

        stage('Docker image tagging') {
            steps {
                sshagent(['ansible-demo']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.84.4 "
                            docker tag ${JOB_NAME}:v1.${BUILD_ID} rahulkumar9536/${JOB_NAME}:v1.${BUILD_ID}
                        "
                    '''
                }
            }
        }
    }
}

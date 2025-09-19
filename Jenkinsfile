pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/my-company-org-95/Kubernetes_Project.git'
            }
        }

        stage('Send Dockerfile & code to Ansible server') {
            steps {
                sshagent(['ansible-demo']) {
                    sh '''
                        scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/flipkart-dev/* \
                        ubuntu@172.31.84.4:/home/ubuntu
                    '''
                }
            }
        }

        stage('Docker Build image') {
            steps {
                sshagent(['ansible-demo']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.84.4 "
                            cd /home/ubuntu && \
                            docker build -t ${JOB_NAME}:v1.${BUILD_ID} .
                        "
                    '''
                }
            }
        }

        stage('Docker Tag image') {
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

        stage('Docker Push to DockerHub') {
            steps {
                sshagent(['ansible-demo']) {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@172.31.84.4 "
                                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin && \
                                docker push rahulkumar9536/${JOB_NAME}:v1.${BUILD_ID} && \
                                docker tag rahulkumar9536/${JOB_NAME}:v1.${BUILD_ID} rahulkumar9536/${JOB_NAME}:latest && \
                                docker push rahulkumar9536/${JOB_NAME}:latest
                            "
                        '''
                    }
                }
            }
        }

        stage('Copy files from Ansible to Kubernetes server') {
            steps {
                sshagent(['kubernetes_server']) {
                    sh '''
                        scp -o StrictHostKeyChecking=no ubuntu@172.31.84.4:/home/ubuntu/* \
                        ubuntu@172.31.89.49:/home/ubuntu/
                    '''
                }
            }
        }

        stage('Kubernetes Deployment using ansible') {
            steps {
                sshagent(['ansible-demo']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.84.4 "
                            cd /home/ubuntu && \
                            ansible-playbook ansible.yml
                        "
                    '''
                }
            }
        }
    }
}

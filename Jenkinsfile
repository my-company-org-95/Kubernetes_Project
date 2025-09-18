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
                    // Copy files to the Ansible server
                    sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/flipkart-dev/* ubuntu@172.31.84.4:/home/ubuntu'
                }
            }
        }
    }
}


pipeline{
    agent any
    stages{
        stage('vcs'){
            steps{
                git url: 'https://github.com/Pallelavanya/terrform.git',
                branch: 'main'
            }
        }
        stage('terraform init'){
            steps{
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply -auto-approve'
            }
            
        }
    }
 }

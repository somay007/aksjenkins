pipeline {
    agent any

    environment {
        ACR_NAME = 'acrregistry932409'
        AZURE_CREDENTIALS_ID = 'azure-service-principal'
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME = 'webapidocker1'
        IMAGE_TAG = 'latest'
        RESOURCE_GROUP = 'rg-aks'
        AKS_CLUSTER = 'aksclusterfordotnetviajenkins'
        TERRAFORM_PATH = '"C:\\Users\\hp\\Downloads\\terraform_1.11.3_windows_386\\terraform.exe"'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/somay007/aksjenkins.git'
            }
        }


        stage('Build Docker Image') {
            steps {
                bat "docker build -t %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG% -f aksviajenkins/Dockerfile aksviajenkins"
            }
        }

        stage('Terraform Init') {
           steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat '"%TERRAFORM_PATH%" -chdir=terraform init '
          }
           }
        
    }
      stage('Terraform Plan & Apply') {
           steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                     bat '"%TERRAFORM_PATH%" -chdir=terraform plan -out=tfplan'
                    bat 'az role assignment create --assignee 2e9e6ee3-d145-4ad6-afd8-5f95f2dc68cf --role "User Access Administrator" --scope /subscriptions/2e35691f-5103-4cad-a61c-dbc64c14af55'

                     bat '"%TERRAFORM_PATH%" -chdir=terraform apply -auto-approve tfplan'
                }
           }
     }
        stage('Login to ACR') {
            steps {
                bat "az acr login --name %ACR_NAME%"
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                bat "docker push %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG%"
            }
        }

        stage('Get AKS Credentials') {
            steps {
                bat "az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER% --overwrite-existing"
            }
        }

        stage('Deploy to AKS') {
            steps {
                bat "kubectl apply -f aksviajenkins/deployment.yaml"
            }
        }
    }

    post {
        success {
            echo 'All stages completed successfully!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}

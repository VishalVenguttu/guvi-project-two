pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'vishalsezhiyan'
        IMAGE          = "${DOCKERHUB_USER}/trend-app"
        TAG            = "${env.BUILD_NUMBER}"
        AWS_REGION     = 'eu-north-1'
        CLUSTER_NAME   = 'trend-eks'
    }

    triggers { githubPush() }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE:$TAG -t $IMAGE:latest .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                    sh '''
                        echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
                        docker push $IMAGE:$TAG
                        docker push $IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-creds']]) {
                    sh '''
                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                        sed -i "s|image: .*|image: $IMAGE:$TAG|" k8s/deployment.yaml
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                        kubectl rollout status deployment/trend-app --timeout=180s
                        kubectl get svc trend-app-svc
                    '''
                }
            }
        }
    }

    post {
        always  { sh 'docker logout || true' }
        success { echo 'Deployed successfully.' }
        failure { echo 'Pipeline failed - check the stage logs.' }
    }
}

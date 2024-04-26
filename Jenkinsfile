pipeline {
    agent any
    
    tools {
        dockerTool 'docker'
        //   maven 'M2'

    }

    environment {
        imageName = "skistation:0.0.1"
        registryUsername= "admin"
        registryCredentials = "Nexus"
        registry = "localhost:8085"
        dockerImage = ''
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/mayssa-benabdallah/Ski-Station-Project'
            }
        }

        stage('Build') {
            steps {
                withMaven(maven: 'mvn') {
                  sh 'mvn clean install -DskipTests'
                }
            }

        }
        
        stage('sonarqube'){
            steps{
              withMaven(maven: 'mvn') {
                sh '''
                    mvn clean verify sonar:sonar\
                        -Dsonar.projectKey=skistation \
                        -Dsonar.projectName=skistation\
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.token=sqp_ed21170bc9ca103c945f9d3c39fb59faed8010af \
                        -DskipTests
                '''
                }
            }
            
        }

        stage('dockerize the app') {
            steps {
                sh 'echo dockerize'
                sh 'docker build -t localhost:8085/skiapp:1.0 .'
            }
        }

        stage('Uploading to Nexus') {
            steps {
                sh '''
                docker login localhost:8085 -u admin -p 000000
                docker push localhost:8085/skiapp:1.0
                '''

            }
        }


        stage('Start Application') {
            steps {
                sh '''
                docker compose up -d
                '''
            }
        }
    }
}
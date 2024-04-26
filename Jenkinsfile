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
            agent {
                docker {
                    image 'maven:3.9.6'
                }
            }
            steps {
                // Run Maven on a Unix agent.
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
                sh 'mvn clean install -DskipTests'
            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target/*.jar'
                }
            }
        }
        
        stage('sonarqube'){
            agent { 
                docker { 
                    image 'sonarsource/sonar-scanner-cli' 
                    args ' --network devops'
                } 
            }
            steps{
                sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=skistation\
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://sonarqube:9000 \
                    -Dsonar.login=admin \
                    -Dsonar.password=000000
                '''
                }
            
        }

        stage('dockerize the app') {
            steps {
                sh 'echo dockerize'
                sh 'docker build -t localhost:8085/skiapp:1.0 .'
                // sh 'docker build -t ${{registry}}/${{imageName}} .'
            }
        }

        stage('Uploading to Nexus') {
            steps {
                sh '''
                
                docker login localhost:8085 -u admin -p 000000
                docker push localhost:8085/skiapp:1.0
                
                
                '''
                //sh 'docker login ${{registry}} -u ${{registryCredentials}} -p ${{registryUsername}}'
                //sh 'docker push ${{registry}}/${{imageName}}'
            }
        }
    }
}
<<<<<<< HEAD
pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['QA', 'Stage', 'Prod'], description: 'Deployment environment')
        string(name: 'S3_BUCKET', defaultValue: 'vprofile-', description: 'S3 bucket')
    }
    environment {
        version = ''
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    if (params.DEPLOY_ENV == 'QA') {
                        checkout(
                            [$class: 'GitSCM',
                            branches: [[name: '*/qa']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github',
                                url: 'git@github.com:vinnu467/vprofile-app.git'
                            ]]
                            ]
                        )
                    } else { 
                        // For Stage and Prod, switch to master branch
                        checkout(
                            [$class: 'GitSCM',
                            branches: [[name: '*/master']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github',
                                url: 'git@github.com:vinnu467/vprofile-app.git'
                            ]]
                            ]
                        )
                    }
                }
            }
        }
        stage('Read POM') {
            steps {
                script {
                    def pom = readMavenPom file: 'pom.xml'
                    version = pom.version
                    echo "Project version is: ${version}"
                }
            }
        }
        stage("Build Artifact") {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }
        stage("Upload Artifact s3") {
            steps {
                script {
                    sh "aws s3 cp target/vprofile-${version}.war s3://${S3_BUCKET}/vprofile-${version}-${DEPLOY_ENV}.war"
                }
            }
        }
        stage('Deploy to CodeDeploy') {
        steps {
            script {
            def deploymentGroup
            switch (params.DEPLOY_ENV) {
                case 'QA':
                deploymentGroup = 'Vprofile-App-qa'
                break
                case 'Stage':
                deploymentGroup = 'Vprofile-App-stage'
                break
                case 'Prod':
                deploymentGroup = 'Vprofile-App-production'
                break
                default:
                error('Invalid environment selected')
            }

            sh "aws deploy create-deployment --application-name  vprofile-application --deployment-group-name ${deploymentGroup} --s3-location bucket=vprofile-bundle,key=deploy-bundle.zip,bundleType=zip"
            }
        }
    }
   }
}
=======
pipeline {
    agent any
      parameters {
        choice(name: 'DEPLOY_ENV', choices: ['QA', 'Stage', 'Prod'], description: 'Deployment environment')
        string(name: 'SERVER_IP', defaultValue: '3.110.159.232', description: 'Server IP')
        string(name: 'S3_BUCKET', defaultValue: 'vprofile-', description: 'S3 bucket')
    }
    environment {
        version = ''
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    if (params.DEPLOY_ENV == 'QA') {
                        checkout(
                            [$class: 'GitSCM',
                            branches: [[name: '*/qa']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github',
                                url: 'git@github.com:vinnu467/vprofile-app.git'
                            ]]
                            ]
                        )
                    } else { 
                        // For Stage and Prod, switch to master branch
                        checkout(
                            [$class: 'GitSCM',
                            branches: [[name: '*/master']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github',
                                url: 'git@github.com:vinnu467/vprofile-app.git'
                            ]]
                            ]
                        )
                    }
                }
            }
        }
        stage('Read POM') {
            steps {
                script {
                    def pom = readMavenPom file: 'pom.xml'
                    version = pom.version
                    echo "Project version is: ${version}"
                }
            }
        }
        stage("Build Artifact") {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }
        stage("Upload Artifact s3") {
            steps {
                script {
                    sh "aws s3 cp target/vprofile-${version}.war s3://${S3_BUCKET}/vprofile-${version}-${DEPLOY_ENV}.war"
                }
            }
        }
        stage('Deploy') {
            steps {
                   sshagent(credentials: ['ec2-creds']) {
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@${SERVER_IP}  'aws s3 cp s3://${S3_BUCKET}/vprofile-${version}-${DEPLOY_ENV}.war ~/'"
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@${SERVER_IP} 'sudo mv ~/vprofile-${version}-${DEPLOY_ENV}.war /var/lib/tomcat9/webapps/'"
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@${SERVER_IP} 'sudo systemctl restart tomcat9'"
                }
            }
        }
    }
}
>>>>>>> master

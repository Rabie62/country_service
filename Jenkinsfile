pipeline {
    agent any

    tools {
        maven 'M2_HOME'
        jdk 'JDK25'
    }

    stages {
        stage('Checkout code') {
            steps {
                git branch: 'main', url: 'https://github.com/Rabie62/country_service.git'
            }
        }

        stage('Compile & Test (JaCoCo & Surefire)') {
            steps {
                // Compilation, exécution des tests et génération des rapports JaCoCo
                sh 'mvn clean test jacoco:report'
            }
            post {
                success {
                    // Collecte des résultats de tests Surefire dans Jenkins
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Analyse statique du code via SonarQube
                withSonarQubeEnv(installationName: 'MySonarQubeServer', credentialsId: 'sonarqubePWD') {
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=country-service'
                }
            }
        }

        stage('Deploy Artifact to Nexus') {
            steps {
                // Déploiement du .jar dans le référentiel Nexus (sans rejouer les tests)
                sh 'mvn deploy -DskipTests'
            }
        }

        stage('Upload Reports to Nexus') {
            steps {
                // Compression et envoi des rapports JaCoCo et Surefire vers le dépôt raw de Nexus
                sh '''
                    # 1. Archive des rapports de couverture JaCoCo
                    tar -czf jacoco-report.tar.gz -C target/site/jacoco .

                    # 2. Archive des rapports de tests Surefire
                    tar -czf surefire-report.tar.gz -C target/surefire-reports .

                    # 3. Envoi sur le dépôt raw-reports de Nexus via cURL
                    curl -v -u admin:wagan2023 --upload-file jacoco-report.tar.gz http://localhost:8081/repository/raw-reports/reports/jacoco-report.tar.gz
                    curl -v -u admin:wagan2023 --upload-file surefire-report.tar.gz http://localhost:8081/repository/raw-reports/reports/surefire-report.tar.gz
                '''
            }
        }
    }
}

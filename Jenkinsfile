pipeline{
        agent any
        environment {
                def mvnHome = tool name: 'maven', type: 'maven'
                def mvnCMD = "${mvnHome}/bin/mvn"
        }
		stages{
			stage('SCM Checkout'){
				steps{
					git credentialsId: 'git-creds', url: 'https://github.com/chairulm/jenkins_master', branch: 'main'
				}
			}
			stage('Mvn Package'){
				steps{
					sh "${mvnCMD} clean package"
				}
			}
			stage('Build Docker Image'){
				steps{
					sh 'docker build -t chairulfm/app1:2.0 .'
				}
			}
			stage('Push Docker Image'){
				steps{
					withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
							sh "docker login -u chairulfm -p ${dockerHubPwd}"
					}
					sh 'docker push chairulfm/app1:2.0'
				}
			}
			stage('Run Container on Dev Server'){
				steps{
					script {
						def dockerRun = 'docker run -p 8080:8080 -d --name app1 chairulfm/app1:2.0'
						def dockerStop = 'docker stop app1'
						def server = '192.168.5.229'
					
						sshagent(['openstack']) {
								try{
										sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerStop}"
								}catch (err){
								}
								sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} docker system prune -af"
								sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerRun}"
						}
					}
				}
			}
			stage('Preparing Artifactory Access'){
				steps{
					rtServer (
						id: "artifactory",
						url: 'http://10.0.0.182:8082/artifactory',
						username: 'admin',
						password: '1234!Abcdef'
					)
				}
			}
			stage('Upload To Artifactory'){
				steps{
					rtUpload (
						serverId: "artifactory",
						spec: '''{
							"files": [
							{
								"pattern": "*.war",
								"target": "app1"
							}
							]
						}''',
					)
				}
			}
			stage('Publish Build Info'){
				steps{
					rtPublishBuildInfo (
						serverId: "artifactory"
					)
				}
			}
			stage('Run Container on Production Server'){
				steps{
					script {
						def dockerRun = 'docker run -p 8080:8080 -d --name app1 chairulfm/app1:2.0'
						def dockerStop = 'docker stop app1'
						def server = '192.168.5.227'
					
						sshagent(['openstack']) {
								try{
										sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerStop}"
								}catch (err){
								}
								sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} docker system prune -af"
								sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerRun}"
						}
					}
				}
			}
		}
}


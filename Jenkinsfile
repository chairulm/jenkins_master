node{
	stage('SCM Checkout'){
		git credentialsId: 'git-creds', url: 'https://github.com/chairulm/jenkins_master', branch: 'main'
	}
	stage('Mvn Package'){
		def mvnHome = tool name: 'maven', type: 'maven'
		def mvnCMD = "${mvnHome}/bin/mvn"
		sh "${mvnCMD} clean package"
	}
	stage('Build Docker Image'){
		sh 'docker build -t chairulfm/app1:2.0 .'
	}
	stage('Push Docker Image'){
		withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
			sh "docker login -u chairulfm -p ${dockerHubPwd}"
		}
		sh 'docker push chairulfm/app1:2.0'
	}
	stage('Run Container on Dev Server'){
		def dockerRun = 'docker run -p 8080:8080 -d --name app1 chairulfm/app1:2.0'
		def dockerStop = 'docker stop app1'
		def server = '192.168.5.213'
		sshagent(['openstack']) {
			try{
				sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerStop}"
			}
			sh 'ssh -o StrictHostKeyChecking=no ubuntu@${server} docker system prune -af'
			sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerRun}"
		}
	}
        stage('Run Container on Production Server'){
                def dockerRun = 'docker run -p 8080:8080 -d --name app1 chairulfm/app1:2.0'
                def dockerStop = 'docker stop app1'
                def server = '192.168.5.208'
                sshagent(['openstack']) {
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerStop}"
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@${server} docker system prune -af'
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${server} ${dockerRun}"
                }
        }
}

pipeline {
  agent any

  stages {
    stage('fetch code') {
      steps {
        git branch: 'hexo', credentialsId: 'jenkins_docker_ssh', poll: false, url: 'git@github.com:screw-hand/screw-hand.github.io.git/'
      }
    }
    stage('build') {
        steps {
          nodejs('v14.19.3(mirror)') {
            sh '''
                npm config list;
                yarn -v;
                yarn
            '''
          }
      }
    }
    stage('deploy') {
      steps {
        nodejs('v14.19.3(mirror)') {
          sh '''
            eval `ssh-agent -s`
            ssh-add /var/jenkins_home/.ssh/jenkins_docker_ssh;
            ssh-add /var/jenkins_home/.ssh/screwhand;

            git config --global user.email "screwhand0@gmail.com"
            git config --global user.name "jenkins-boot"

            yarn deploy;
            
            tar -zcvf docker.tar.gz docker;
            tar -zcvf blog.tar.gz public;
          '''
        }

        sshPublisher(publishers: [sshPublisherDesc(configName: 'screwhand_aliyun', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''  cd /root/screw-hand;
          tar -zxvf docker.tar.gz 2> /dev/null;
          cp -r docker/* .;
          rm -rf docker/; 
          docker rmi screw-hand_nginx;
          docker stop screw-hand_nginx;
          docker rm screw-hand_nginx;
          docker build -t screw-hand_nginx .;
          docker-compose up -d;
          docker images;
          docker ps;
          ls -last;''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/root/screw-hand', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'docker.tar.gz')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
          
        sshPublisher(publishers: [sshPublisherDesc(configName: 'screwhand_aliyun', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''  cd /root/screw-hand;
          cp -r blog old-blog;
          tar -zxvf blog.tar.gz 2> /dev/null;
          cp -r public/* blog/;
          rm -rf public;
          ls -last;''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/root/screw-hand', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'blog.tar.gz')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
      }
    }
    stage('email') {
      post {
        alawys {
          emailext 
            body: '${FILE,path="email.html"}',
            recipientProviders: [buildUser()],
            subject: '${BUILD_STATUS}:${ENV, var="JOB_NAME"}-第${BUILD_NUMBER}次构建日志'
        }
      }
    }
  }
}

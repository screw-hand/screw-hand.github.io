set -ex

# env variable
SERVER_IP=120.77.80.139
SERVER_USER=root
DEPLOY_PATH=/root/screw-hand

# config 
eval `ssh-agent -s`
ssh-add ~/.ssh/screwhand
#ssh -T git@github.com   # 如果执行，则报错
npm config list
npm i -g yarn
yarn -v
yarn

#deploy for github pages
yarn deploy

# TODO 判断版本
# build docker images
tar -zcvf docker.tar.gz docker
scp -r docker.tar.gz ${SERVER_USER}@${SERVER_IP}:${DEPLOY_PATH}
ssh ${SERVER_USER}@${SERVER_IP} \
"
  cd $DEPLOY_PATH;
  ls;
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
  ls -last;
"

# upload blog code
tar -zcvf blog.tar.gz public
scp -r blog.tar.gz ${SERVER_USER}@${SERVER_IP}:${DEPLOY_PATH}
ssh ${SERVER_USER}@${SERVER_IP} \
"
  cd $DEPLOY_PATH;
  ls;
  cp -r blog old-blog;
  tar -zxvf blog.tar.gz 2> /dev/null;
  cp -r public/* blog/;
  rm -rf public;
  ls -last;
  # TODO  清空nginx缓存
  exit;
"

# TODO 判断是否为Jenkins环境
# Jenkins环境不删除此压缩包
# rm -rf docker.tar.gz
# rm -rf blog.tar.gz
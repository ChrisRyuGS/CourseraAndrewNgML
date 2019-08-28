#!/usr/bin/env bash

AWS_ACCOUNT_ID=584672986561
AWS_SECRET_ACCESS_KEY=KPIl994jebXh/1oh+0RtK8+BLjvnew0Mdp3e0jM3=


docker build -t edurom .
docker tag edurom:latest $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:latest

configure_aws_cli(){
	aws --version
	aws configure set default.region ap-northeast-2
	aws configure set default.output json
}

push_ecr_image(){
    eval $(aws ecr get-login --no-include-email --region ap-northeast-2)
    docker push $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:latest
}

pull_ecr_image(){
    eval $(aws ecr get-login --no-include-email --region ap-northeast-2)
    docker pull $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:latest
    docker stop edurom 
    docker rm edurom
    docker rmi $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:current  
    docker tag $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:latest $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:current  
    docker run -d --name edurom $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:latest  
    docker run --name awsedurom -v mysql-data:/var/lib/mysql -p 4000:4000 -p 1812-1813:1812-1813/udp -p 80:80 -p 27017:27017 -p 3306:3306 -d 584672986561.dkr.ecr.ap-northeast-2.amazonaws.com/edurom:current
}
configure_aws_cli
#push_ecr_image
pull_ecr_image

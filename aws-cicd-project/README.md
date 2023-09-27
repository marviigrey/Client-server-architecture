In this project we will be deploying a java application with AWS
code family which consist of:
1. AWS CodeCommit which serves as a git repository.
2. AWS CodeArtifact: this is an AWS managed artifactory.
3. AWS CodeBuild: this service is used to run tests and produce software packages.
4. AWS CodeDeploy: A software Deployment Service.
5. AWS CodePipeline: This creates an automated Pipeline for continuous Deployment and Integration.

Description of the project:
We are going to run a CiCd pipeline to deploy a java application into an EC2 instance
and later on we containerize the application and publish it to Amazon ECR (Elastic Container Registry).

Steps:
1. setting up our environment which the first will be creating a cloud9 environment.
Log in to AWS console and search cloud9. navigate to the cloud9 dashboard and
create a single environment called "aws-code-family".
  - we install apache Maven and Java. open your cloud9 environment,on the terminal paste
    the following lines of code to install java and apache maven. java jdk is a
    prerequisite for the apache maven. while maven is an automation tool we use
    in building java application. 
  - we wil also install Amazon Correto 8, a free,production ready distribution
    of the openJDK.
  
   
    sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
    sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
    sudo yum install -y apache-maven

    sudo amazon-linux-extras enable corretto8
    sudo yum install -y java-1.8.0-amazon-corretto-devel
    export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64
    export PATH=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64/jre/bin/:$PATH

   //https://git-codecommit.us-east-1.amazonaws.com/v1/repos/unicorn-web-project
    java -version
    mvn -v
2.  Create the java sample web app using maven:

        mvn archetype:generate \
    -DgroupId=com.wildrydes.app \
    -DartifactId=unicorn-web-project \
    -DarchetypeArtifactId=maven-archetype-webapp \
    -DinteractiveMode=false
   
   A directory will be created called unicorn-web-project, explore the directory.
   This will serve as our java source code for the project.
  
3. Setting up AWS CodeCommit,which is a source control service that hosts private
   Git repositories.
    - navigate to the CodeCommit dashboard and create a repository, with the name unicorn-web-project
    - create the repo and select Clone URL using HTTPS. This will automatically copy 
      the URL. in this format:

        https://git-codecommit.<region>.amazonaws.com/v1/repos/<project-name>
    - Next on your cloud9,configure your Git identity
    
        git config --global user.name <username>
        git config --global user.email <user email address>
    - cd ~/environment/unicorn-web-project
      git init -b main
      git remote add origin <HTTPS CodeCommit repo URL>

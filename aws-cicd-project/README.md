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
        cd ~/environment/unicorn-web-project
        git init -b main
        git remote add origin <HTTPS CodeCommit repo URL>
        
        git add *
        git commit -m "new codecommit"
        git push -u origin main
        
    - refresh the dashboard of your codeCommit repository and you will see your files below.
    
4. Next step is to build artifacts using CodeArtifact. This service is fully managed artifactory
   used for to securely fetch,store,publish and share software packages in software
   development process.
   - we navigate to the AWS dashboard and search CodeArtifact. Create a domain 
     with the name "unicorn".
   - after creating a domain, still in the CodeArtifact dashboard, create a repository with the
     name "unicorn-packages", write any description, select maven-central-store as a public upstream.
   - after creating, connect to the CodeArtifact repository. To connect this we will need to fetch an 
     authentication token to connect to our CodeArtifact repository. run:
        
        export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain unicorns --domain-owner <your-domain-owner-id> --query authorizationToken --output text`

   - or you can copy it from the "create connections settings" in your CodeArtifact dashboard.
   - next step is to create a settings.xml file inside our /environment/unicorn-project directory.
   - start the settings.xml file with:
        "<settings> </settings>"
   - in your connections settings you will see the profiles and mirrors code settings, copy and paste them
     into the settings.xml, it will look like the settings.xml file in this repo.

   -  so when we are done we can test the application locally on our cloud9 environment using:
             " mvn -s settings.xml compile "
   - if you get a successul build, check the CodeArtifact dashboard to see the list of compiled packages.
   - Next we create a policy to enable other aws services such as codeBuild,codeDeploy etc to be able to 
    use our newly created CodeArtifact repository. 
    Navigate to the IAM dashboard on AWS console and select policies, create a neew policy and name it 
    "policy-for-codeArtifact". Select JSON and paste this code:

    
    {
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [ "codeartifact:GetAuthorizationToken",
                      "codeartifact:GetRepositoryEndpoint",
                      "codeartifact:ReadFromRepository"
                      ],
          "Resource": "*"
      },
      {       
          "Effect": "Allow",
          "Action": "sts:GetServiceBearerToken",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "sts:AWSServiceName": "codeartifact.amazonaws.com"
              }
          }
      }
  ]
}

create the Policy.


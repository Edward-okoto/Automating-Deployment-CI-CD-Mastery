# Automating-Deployment-CI-CD-Mastery




### **1. Jenkins Server Setup**
**Objective**: Configure Jenkins server for CI/CD pipeline automation.

#### **Steps**:
1. **Install Jenkins**:

   Use the commands from this webpage to install [jenkins](https://phoenixnap.com/kb/install-jenkins-ubuntu) 

   OR
   - Install Java (Jenkins requires Java):
     ```bash
     sudo apt update
     sudo apt install openjdk-11-jdk -y
     ```
     ![](./a1.png)
     ![](./a2.png)
   - Install Jenkins:
     ```bash
     curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
     /usr/share/keyrings/jenkins-keyring.asc > /dev/null
     echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
     https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
     /etc/apt/sources.list.d/jenkins.list > /dev/null
     sudo apt update
     sudo apt install jenkins -y
     sudo systemctl start jenkins
     sudo systemctl enable jenkins
     ```
     Jenkins requires an admin user and password for login:

     During the initial setup, Jenkins generates a default admin password.

     Locate the initial password file:

            sudo cat /var/lib/jenkins/secrets/initialAdminPassword

     Paste the code in the Administrator password field in the Jenkins unlock page and click Continue and install suggested plugins.


     ![](./a3.png)

2. **Set Up Necessary Plugins**:
   - Navigate to **Jenkins Dashboard > Manage Jenkins > Manage Plugins**.
   - Install the following plugins:
     - **Git Plugin**: Integrates GitHub.
     - **Docker Pipeline Plugin**: Handles Docker commands.
     - **Pipeline Maven Integration Plugin**: Enables Maven builds.
     - **Blue Ocean Plugin**: Improves pipeline visualization.

3. **Configure Jenkins Security**:
   - Set up an admin user during the first-time setup.

     ![](./a4.png)
     
   - Enable **CSRF Protection** under **Manage Jenkins > Configure Global Security**.
   - Install the **Role-Based Authorization Strategy** plugin to assign permissions to users.

---

### **2. Source Code Management Repository Integration**
**Objective**: Connect Jenkins to GitHub for source code management.

#### **Steps**:
1. **Integrate Jenkins with GitHub**:
   - Add GitHub credentials:
     - Navigate to **Manage Jenkins > Credentials**.
     - Add a new credential with your GitHub personal access token.

     ![](./a6.png)

   - Configure the repository in Jenkins:
     - In the job configuration, specify the GitHub repository URL and associate the credentials.

     ![](./a7.png)

2. **Set Up Webhooks**:
   - Go to your GitHub repository settings:
     - Navigate to **Settings > Webhooks > Add webhook**.
     - Enter the Payload URL: `http://<jenkins-server-ip>:8080/github-webhook/`.
     - Set content type to `application/json`.
   - Enable the webhook to trigger builds automatically when code is pushed.

     ![](./a8.png)

---

### **3. Jenkins Freestyle Jobs for Build and Unit Tests**
**Objective**: Create Jenkins freestyle jobs to build and test the application.

#### **Steps**:
1. **Set Up a Freestyle Job**:
   - Create a new freestyle job:
     - Navigate to **Dashboard > New Item > Freestyle Project**.
     - Configure the job to pull source code from GitHub.

     ![](./a9.png)

     ![](./a5.png)

   - Define build steps:
     - Add shell commands to build and run tests:
       ```bash
       mvn clean install

       mvn test
       ```
    ![](./a10.png)


2. **Post-Build Actions**:
   - Configure actions like archiving artifacts or sending notifications.
    
    ![](./a11.png)

    ![](./a12.png)

---

### **4. Jenkins Pipeline for Web Application**
**Objective**: Develop a Jenkins pipeline script for automating the CI/CD process.

#### **Steps**:
1. **Create a Declarative Pipeline**:
   - Navigate to **Dashboard > New Item > Pipeline**.
   - Use the following declarative pipeline script:
     ```groovy
     pipeline {
         agent any

         environment {
             DOCKERHUB_USERNAME = credentials('docker-hub-username') // Replace with Docker Hub credential ID
             DOCKERHUB_PASSWORD = credentials('docker-hub-password')
             DOCKER_IMAGE = 'your-dockerhub-username/ecommerce-app:latest'
         }

         tools {
             maven 'Maven 3' // Name of Maven installation in Jenkins Global Tool Configuration
         }

         stages {
             stage('Checkout Code') {
                 steps {
                     git branch: 'main', url: 'https://github.com/your-repo.git'
                 }
             }

             stage('Build and Test') {
                 steps {
                     sh 'mvn clean install'
                 }
             }

             stage('Build Docker Image') {
                 steps {
                     sh "docker build -t $DOCKER_IMAGE ."
                 }
             }

             stage('Push Docker Image') {
                 steps {
                     script {
                         sh """
                         echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                         docker push $DOCKER_IMAGE
                         """
                     }
                 }
             }
         }

         post {
             always {
                 echo 'Pipeline execution completed!'
             }
         }
     }
     ```

---

### **5. Docker Image Creation and Registry Push**
**Objective**: Automate Docker image creation and push to Docker Hub.

#### **Steps**:
1. **Create Dockerfile**:
   - Add a `Dockerfile` to your project repository:
     ```dockerfile
     FROM openjdk:11-jdk-slim
     WORKDIR /app
     COPY target/ecommerce-app.jar /app/ecommerce-app.jar
     ENTRYPOINT ["java", "-jar", "/app/ecommerce-app.jar"]
     ```

2. **Configure Docker in Jenkins**:
   - Ensure Docker is installed and Jenkins has permission to execute Docker commands:
     ```bash
     sudo usermod -aG docker jenkins
     sudo systemctl restart jenkins
     ```

3. **Push Docker Image to Docker Hub**:
   - The declarative pipeline script above includes steps to log in to Docker Hub and push the image.

4. **Run and Test the Container**:
   - After the pipeline pushes the Docker image, run the container locally or on a server:
     ```bash
     docker run -d -p 3000:3000 your-dockerhub-username/ecommerce-app:latest
     ```
   - Access the application in your browser at `http://<server-ip>:3000`.

---


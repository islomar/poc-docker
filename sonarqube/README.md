#SonarQube with Docker

##How to setup a SonarQube server

If you want to install a SonarQube in your local machine, follow these instructions:

1. Run the script `run_postgresql_and_sonarqube.sh`:
* The first time you run it, it will download the images
* Then, it will create and run both a PostgreSQL and a SonarqQube containers

2. Access the URL http://localhost:9000 to check that SonarQube is up and running

3. For using it with Python, follow the instructions here: https://docs.sonarqube.org/display/PLUG/SonarPython
* Install SonarQube scanner and configure it to point to your SonarQube server (you can find the zip file in this folder):
    * https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
    * Basically, you have to uncomment the sonar.host.url property in the sonar-scanner.properties file
* Access the SonarQube sersver (admin/admin), in order to:
    * Install SonarPython plugin
    * Intall Pylint

4. Copy the file *sonar-project.properties* into the root folder of your project, changing the key and name.

5. Run `sonar-scanner` from your project folder

6. Access the SonarQube server to wathc the results

7. After finishing using it, stop the containers and remove them:
`docker stop $(docker ps -a -q)`
`docker rm $(docker ps -a -q)`


##Recommended links:
http://www.xgomez.com/2016/12/quickest-static-code-analysis-with-sonar-and-docker/
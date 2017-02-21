FROM debian:stretch

RUN apt-get update
RUN apt-get -y install wget apt-transport-https unzip gnupg

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -

RUN echo "deb https://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y install jenkins

COPY install/ /install/
RUN chown jenkins.  /install \
 && chmod +x /install/*.sh

RUN /etc/init.d/jenkins start \
 && su - jenkins -c  "/install/plugins.sh" \
 && su - jenkins -c "cd /install;unzip -j -C /usr/share/jenkins/jenkins.war WEB-INF/jenkins-cli.jar"

RUN /etc/init.d/jenkins start \
 && contrasenya=`cat /var/lib/jenkins/secrets/initialAdminPassword` \
 && echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("jenkins", "jenkins")' | java -jar /install/jenkins-cli.jar -s http://localhost:8080/ groovy = --username admin --password $contrasenya

CMD /etc/init.d/jenkins start \
 && /bin/bash

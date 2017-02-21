FROM oraclelinux:6

RUN yum install -y wget unzip

RUN wget --no-check-certificate -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo \
 && wget --no-check-certificate -O jenkins.io.key https://pkg.jenkins.io/redhat-stable/jenkins.io.key \
 && rpm --import jenkins.io.key \
 && yum install -y jenkins java-1.8.0-openjdk

COPY install/ /u01/install/
COPY scrics/  /u01/scrics/
RUN chown -R jenkins. /u01/ \
 && chmod +x /u01/install/*.sh /u01/scrics/*.sh

RUN /u01/scrics/start_jenkins.sh \
 && /u01/install/plugins.sh \
 && cd /u01/install \
 && unzip -j -C /usr/lib/jenkins/jenkins.war WEB-INF/jenkins-cli.jar \
 && chown jenkins. /u01/install/jenkins-cli.jar \
 && while ( ! ls /var/lib/jenkins/secrets/initialAdminPassword ); do sleep 10;done;contrasenya=`cat /var/lib/jenkins/secrets/initialAdminPassword` \
 && echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("jenkins", "jenkins")' | java -jar /u01/install/jenkins-cli.jar -s http://localhost:8080/ groovy = --username admin --password $contrasenya

CMD /u01/scrics/start_jenkins.sh \
 && /bin/bash

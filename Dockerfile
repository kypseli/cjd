FROM cloudbees/cloudbees-jenkins-distribution:2.164.3.2

# optional, but you might want to let everyone know who is responsible for their Jenkins ;)
LABEL maintainer "kmadel@cloudbees.com"

#set java opts variable to skip setup wizard; plugins will be installed via license activated script
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
#skip setup wizard; per https://github.com/jenkinsci/docker/tree/master#preinstalling-plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# diable cli
ENV JVM_OPTS -Djenkins.CLI.disabled=true -server
# set your timezone
ENV TZ="/usr/share/zoneinfo/America/New_York"

#config-as-code plugin configuration
COPY config-as-code.yml /usr/share/jenkins/config-as-code.yml
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/config-as-code.yml

# use CloudBees' update center to ensure you don't allow any really bad plugins
ENV JENKINS_UC http://jenkins-updates.cloudbees.com

#install suggested and additional plugins
COPY plugins.txt plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat plugins.txt)

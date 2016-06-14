FROM ubuntu:latest

RUN apt-get update

#Creating Folder Structure for build
RUN cd /
RUN mkdir -p /app/Swift
RUN mkdir -p /app/SwiftBuild/SwiftBuildOutput/build
RUN mkdir -p /app/SwiftBuild/SwiftBuildOutput/logs

#Adding Build files
ADD SwiftCreateBuild.xml /app/SwiftBuild/SwiftCreateBuild.xml
ADD Platformbuild.xml /app/SwiftBuild/Platformbuild.xml
ADD SwiftCreateBuild.properties /app/SwiftBuild/SwiftCreateBuild.properties
RUN mkdir -p /usr/local/share/ca-certificates
ADD ganesha.digite.in.crt /usr/local/share/ca-certificates/ganesha.digite.in.crt

#Installing java inside container
ADD jdk1.6.0_45 /app/jdk1.6.0_45
RUN chmod -R 777 /app/jdk1.6.0_45
RUN ln -s /app/jdk1.6.0_45/bin/java /usr/local/bin/
RUN ln -s /app/jdk1.6.0_45/bin/javac /usr/local/bin/


#installing 7z inside ccontainer
RUN apt-get install p7zip-full

#Installing ant inside container
ADD ant /app/ant
RUN chmod -R 777 /app/ant
RUN ln -s /app/ant/bin/ant /usr/local/bin/

#Setting path for Java and ANT
RUN { \
  echo 'export JAVA_HOME=/app/jdk1.6.0_45'; \
  echo 'export PATH=$PATH:$JAVA_HOME/bin'; \
  echo 'export ANT_HOME=/app/ant'; \
  echo 'export PATH=$PATH:$ANT_HOME/bin'; \
 } > ~/.bashrc

#ADD setPathFile /app/setPathFile

#RUN cd /app
#RUN cat /app/setPathFile >> ~/.bashrc

RUN apt-get -y install subversion

RUN cd /app/SwiftBuild

WORKDIR /app/SwiftBuild

CMD ["ant","-f","SwiftCreateBuild.xml","-logfile","antOutputLog.log"]



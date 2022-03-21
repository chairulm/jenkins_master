FROM tomcat:8
LABEL app=app1
COPY target/*.war /usr/local/tomcat/webapps/

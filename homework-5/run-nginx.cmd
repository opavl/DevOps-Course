@REM pull Docker image from Docker hub
docker pull opavl/devops5-course-nginx

@REM run nginx container on port :80
docker run -d -p 80:80 opavl/devops5-course-nginx
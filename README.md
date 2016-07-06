### DOCKER for Postgresql ###
1. Install Docker and Docker-Compose
2. Run
    2.1/ Creating a docker container for data only [optional]:
        - docker-compose -f docker-compose.yml -d --service-ports dataonly
    2.2/ Running a docker container for postgresql
       - docker-compose -f docker-compose.yml -d --service-ports base
### docker-compose version 1.7.1 
### Docker version 1.9.1
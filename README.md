# PHP FPM Docker container for Drupal

This project builds a container for running PHP FPM as part of a Drupal web site stack.

This Dockerfile image is for building the time consumming compiles and downloads as a base image. Configuration of php and additional settings are configured in docker-compose and decompose.

Other parts include:

- nginx image
- mariadb image
- docker-compose for container orchestration
- decompose for configuration

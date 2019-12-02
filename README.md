# Symfony4 dev environment
### Setup
- PHP 7.3
- Nginx
- MySQL 5.7
- Composer
- Git
- PhpUnit
- ELK 7.4.2

### Additional goodies, i.e. PHP code quality tools
The major tool which is used is GrumPHP https://github.com/phpro/grumphp and is configured to run the following tools:
- phpmd - https://github.com/phpro/grumphp/blob/master/doc/tasks/phpmd.md
- phpcs - https://github.com/phpro/grumphp/blob/master/doc/tasks/phpcs.md 
- phpstan - https://github.com/phpro/grumphp/blob/master/doc/tasks/phpstan.md
- phpunit - https://github.com/phpro/grumphp/blob/master/doc/tasks/phpunit.md

The upper tools are fired in a pre-commit git hook and are configured by the following files in main dir:
- grumphp.yml
- phpmd_rulesets.xml

### Prerequisites
- You must have Git installed.
- You must add the proper virtual host record to your /etc/hosts file, i.e.
    - 127.0.0.1	symfony4.local
    - In case you want a different name, you must specify it in ./devops/nginx/conf.d/server.conf
- You must be able to execute Makefiles via 'make' command. Otherwise you must take a look at ./Makefile and execute the commands by hand. You may try to install make via `sudo apt-get install make` if you don't have it.

### Configuration
- Configuration is in .env and there you can tweak some Docker params, database setup and symfony stuff.
- In case your uid and gid are not 1000 but say 1001, you must change the USER_ID and GROUP_ID vars in .env-dist before launching setup. Type the `id` command in your terminal in order to find out who you are.
- Your images will be prefixed with COMPOSE_PROJECT_NAME env var, e.g. `symfony4_web` for the Nginx image. You can change this as per your preference.
- Nginx logs are accessible in Kibana.
- Symfony logs are accessible in Kibana.
- MySQL data is persisted via a Docker volume.
- Composer cache is persisted via a Docker volume.
- Elasticsearch data is persisted via a Docker volume.
- You can write code by loading your project in your IDE, but in order to use Composer or to take advantage of the code quality tools you must work in the PHP container.

### Start the Docker ecosystem for a first time
- `mkdir my_project` - create a new project dir
- `cd my_project` - get into it
- `git clone https://github.com/ebalkanski/symfony4-php-nginx-mysql-elk.git .` - clone code from repo
- `rm -rf .git` - cleanup git data. Now you can init a new fresh repo if you want and work with it.
- `make init`
    - builds Docker images and volumes
    - installs Composer packages
- `make up` - start the whole ecosystem
- `docker-composer ps` - verify all containers are up and running
- Depending on your hardware setup the ELK stack may need some time to start properly.
    - Open `symfony4.local:9200` in your browser and you should see the Elasticsearch JSON config data.
    - Open `symfony4.local:81` in your browser and you should see Kibana.
    - If these two are not loaded yet and you are curious about details, you can monitor the containers' logs with Docker commands:
        - `docker logs symfony4_Elasticsearch`
        - `docker logs symfony4_logstash`
        - `docker logs symfony4_kibana`
- Open `symfony4.local` in your browser and you should see Symfony default page.
- Open `http://symfony4.local:81/app/kibana#/management/kibana/index_patterns?_g=()` and create two index patterns:
    - `monolog` (use the datetime filter on second step of wizard)
    - `nginx` (use the @timestamp filter on second step of wizard)
- Open `http://symfony4.local:81/app/kibana#/discover` and you should see the Symfony logs there. You can also switch to nginx logs.
- `docker-compose exec php /bin/bash` - enter the php container.
- Happy Coding!

### Useful commands
- `make up` - start all containers
- `make php` - hook into the PHP container
- `make down` - stop the running containers
- `make build` - rebuild images

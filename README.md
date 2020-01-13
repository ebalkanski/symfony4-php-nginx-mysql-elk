# Symfony4 dev environment
### Setup
- PHP 7.3
- Nginx
- MySQL 5.7
- Redis
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
- You must have the following tools installed:
    - Git
    - Docker - https://docs.docker.com/install/linux/docker-ce/ubuntu/
    - Docker Compose - https://docs.docker.com/compose/install/
- You must add the proper virtual host record to your /etc/hosts file, i.e.
    - 127.0.0.1	symfony4.local
    - In case you want a different name, you must specify it in ./devops/nginx/dev/config/server.conf

### Configuration
- Configuration is in .env file and there you can tweak some Docker params, database setup and symfony stuff.
- In case your uid and gid are not 1000 but say 1001, you must change the USER_ID and GROUP_ID vars in .env file before launching setup. Type the `id` command in your terminal in order to find out who you are.
- Your images will be prefixed with COMPOSE_PROJECT_NAME env var, e.g. `sf4`. You can change this as per your preference.
- Nginx logs are accessible in Kibana.
- Symfony logs are accessible in Kibana.
- Symfony PHP session is stored in Redis.
- MySQL data is persisted via a Docker volume.
- Composer cache is persisted via a Docker volume.
- Elasticsearch data is persisted via a Docker volume.
- You can write code by loading your project in your IDE, but in order to use Composer or to take advantage of the code quality tools you must work in the PHP container.

### Start the Docker ecosystem for a first time
- `mkdir my_project` - create a new project dir
- `cd my_project` - get into it
- `git clone https://github.com/ebalkanski/symfony4-php-nginx-mysql-elk.git .` - clone code from repo
- `rm -rf .git` - cleanup git data. Now you can init a new fresh repo if you want and work with it.
- Now you would want to run `id` command and set USER_ID and GROUP_ID env vars in .env file as per your needs.
- `docker-compose build` - build Docker images and volumes
- `docker-compose run --rm php-dev composer install` - install Composer packages
- `docker-compose up -d` - start the whole ecosystem
- `docker-compose ps` - verify all containers are up and running
- Depending on your hardware setup the ELK stack may need some time to start properly.
    - Open `http://symfony4.local:9200` in your browser and you should see the Elasticsearch JSON config data.
    - Open `http://symfony4.local:81` in your browser and you should see Kibana.
    - If these two are not loaded yet and you are curious about details, you can monitor the ELK containers' logs with Docker command and see when they are ready:
        - `docker logs container`
- Open `http://symfony4.local` in your browser and you should see Symfony default page.
- Open `http://symfony4.local:81/app/kibana#/management/kibana/index_patterns?_g=()` and create two index patterns:
    - `monolog` (use the datetime filter on second step of wizard)
    - `nginx` (use the @timestamp filter on second step of wizard)
- Open `http://symfony4.local:81/app/kibana#/discover` and you should see the Symfony logs there. You can also switch to nginx logs.
- `docker-compose exec php-dev /bin/bash` - enter the php container.
    - The first time you commit, you will get a warning from PHPStan: "Class PHPUnit\Framework\TestCase not found and could not be autoloaded". Just ignore it and commit again, it will work.
- Happy Coding!

### Useful commands
- `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container` - gets container's IP
- `docker kill -s HUP container` - can be used to reload Nginx configuration dynamically

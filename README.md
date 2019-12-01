# A bunch of Docker containers to make your life easier ;)
### PHP dev environment with basic tools setup
- PHP 7.3
- Nginx
- MySQL 5.7
- Composer
- Git
- PhpUnit

### Additional goodies, i.e. PHP code quality tools.
The major tool which is used is GrumPHP https://github.com/phpro/grumphp and it is configured to run the following tools:
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
    - 127.0.0.1	php.local
    - In case you want a different name, you must specify it in ./devops/nginx/conf.d/server.conf
- You must be able to execute Makefiles via 'make' command. Otherwise you must take a look at ./Makefile and execute the commands by hand. You may try to install make via `sudo apt-get install make` if you don't have it.

### Configuration
- Configuration is in .env(will be created for you based on .env-dist) and there you can tweak database config and some Docker params.
- In case your uid and gid are not 1000 but say 1001, you must change the USER_ID and GROUP_ID vars in .env-dist before launching setup. Type the `id` command in your terminal in order to find out.
- Your images will be prefixed with COMPOSE_PROJECT_NAME env var, e.g. `php_stack_web` for the Nginx images. You can change this as per your preference.
- Nginx logs are accessible in ./volumes/nginx/logs
- MySQL data is persisted via a Docker volume.
- Composer cache is persisted via a Docker volume.
- You can write code by loading your project in your favourite IDE, but in order to use Composer or to take advantage of the code quality tools you must work in the PHP container.

### Start the Docker ecosystem for a first time
- `mkdir my_project` - create a new project dir
- `cd my_project` - get into it
- `git clone git@github.com:ebalkanski/php-nginx-mysql.git .` - clone code from repo
- `rm -rf .git` - cleanup git data. Now you can init a new fresh repo if you want and work with it.
- `make init`
    - creates .env file
    - builds Docker images and volumes
    - installs Composer packages
- `make up` - start the whole ecosystem
- `docker-composer ps` - verify all containers are up and running
- open `php.local` in your favourite browser and you should see phpinfo() output there.
- `docker-compose exec php /bin/bash` - enter the php container.
- Happy Coding!

### Useful commands
- `make up` - starts all containers
- `make php` - hook into the PHP container
- `make down` - stops the running containers
- `make build` - rebuild images

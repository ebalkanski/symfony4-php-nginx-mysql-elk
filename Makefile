init:
	mkdir -p ~/.composer/cache &&\
	mkdir -p volumes/elasticsearch/data &&\
	docker-compose build --pull --no-cache &&\
	docker-compose run --rm php composer install &&\
	docker-compose down

build:
	docker-compose build

up:
	docker-compose up -d --remove-orphans

down:
	docker-compose down

php:
	docker-compose exec php /bin/bash
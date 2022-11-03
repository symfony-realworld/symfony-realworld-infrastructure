setup:
	@mkdir -p src
	
	# Клонируем микросервис User в директорию ms-user
	@cd src && rm -rf ms-user && git clone --recurse-submodules git@github.com:symfony-realworld/symfony-realworld-user.git ./ms-user
	@cd src && rm -rf ms-post && git clone --recurse-submodules git@github.com:symfony-realworld/symfony-realworld-post.git ./ms-post
	
	# Собираем и поднимаем докер контейнеры
	@cd Docker && docker-compose build
	@cd Docker && docker-compose up -d
	
	# Настраиваем микросервис User
	@cd Docker && docker-compose exec ms_user_php composer install
	@cd Docker && docker-compose exec ms_user_php php bin/console doctrine:database:create --if-not-exists
	@cd Docker && docker-compose exec ms_user_php php bin/console doctrine:migrations:migrate --allow-no-migration
	@cd Docker && docker-compose exec ms_user_php php bin/console lexik:jwt:generate-keypair
	# Настраиваем микросервис Post
	@cd Docker && docker-compose exec ms_post_php composer install
	@cd Docker && docker-compose exec ms_post_php php bin/console doctrine:database:create --if-not-exists
	@cd Docker && docker-compose exec ms_post_php php bin/console doctrine:migrations:migrate --allow-no-migration
	@cd Docker && docker-compose exec ms_post_php php bin/console lexik:jwt:generate-keypair

configure-jwt: 
	@mkdir -p jwt
	@cd jwt && ssh-keygen -t rsa -b 4096 -m PEM -f private.pem
	@cd jwt && openssl rsa -in private.pem -pubout -outform PEM -out public.pem
	
	@cp -R jwt ./src/ms-user/config/jwt
	@cp -R jwt ./src/ms-post/config/jwt

down:
	@cd Docker && docker-compose down -v

up:
	@cd Docker && docker-compose build
	@cd Docker && docker-compose up -d
# Настраиваем микросервис User
	@cd Docker && docker-compose exec ms_user_php composer install
	@cd Docker && docker-compose exec ms_user_php php bin/console doctrine:database:create --if-not-exists
	@cd Docker && docker-compose exec ms_user_php php bin/console doctrine:migrations:migrate --allow-no-migration
	@cd Docker && docker-compose exec ms_user_php php bin/console lexik:jwt:generate-keypair --overwrite
	# Настраиваем микросервис Post
	@cd Docker && docker-compose exec ms_post_php composer install
	@cd Docker && docker-compose exec ms_post_php php bin/console doctrine:database:create --if-not-exists
	@cd Docker && docker-compose exec ms_post_php php bin/console doctrine:migrations:migrate --allow-no-migration
	@cd Docker && docker-compose exec ms_post_php php bin/console lexik:jwt:generate-keypair --overwrite


restart:
	@cd Docker && docker-compose restart

connect-to-user-container:
	@cd Docker && docker-compose exec ms_user_php bash

connect-to-post-container:
	@cd Docker && docker-compose exec ms_post_php bash

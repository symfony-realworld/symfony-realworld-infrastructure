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
	# Настраиваем микросервис Post
	@cd Docker && docker-compose exec ms_post_php composer install

docker-compose-down:
	@cd Docker && docker-compose down

docker-compose-up:
	@cd Docker && docker-compose build
	@cd Docker && docker-compose up -d

connect-to-user-container:
	@cd Docker && docker-compose exec ms_user_php bash

connect-to-post-container:
	@cd Docker && docker-compose exec ms_post_php bash

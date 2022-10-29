setup:
	@mkdir -p src
	
	# Клонируем микросервис User в директорию ms-user
	@cd src && rm -rf ms-user && git clone --recurse-submodules git@github.com:symfony-realworld/symfony-realworld-user.git ./ms-user

	# Клонируем микросервис Post в директорию ms-post
  @cd src && rm -rf ms-post && git clone --recurse-submodules git@github.com:symfony-realworld/symfony-realworld-post.git ./ms-post
  
  # Собираем и поднимаем контейнеры
  @cd Docker && docker-compose build
  @cd Docker && docker-compose up -d

	# Настраиваем микросервис User
	@cd Docker && docker-compose exec ms_user_php composer install
	@cd Docker && docker-compose exec ms_user_php php bin/console doctrine:make:migration
	
	# Настраиваем микросервис Post
	@cd Docker && docker-compose exec ms_post_php composer install
	@cd Docker && docker-compose exec ms_post_php php bin/console doctrine:make:migration
	
bash-ms-user-php:
	@cd Docker & docker-compose exec ms_user_php bash

bash-ms-post-php:
	@cd Docker & docker-compose exec ms_post_php bash

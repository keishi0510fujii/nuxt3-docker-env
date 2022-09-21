include ziped_service_makefiles/utils/docker-command.mk
include ziped_service_makefiles/utils/service-message.mk
include ziped_service_makefiles/nuxt3.mk
include ziped_service_makefiles/nginx.mk

# --------------  variables  --------------
PRODUCT_PREFIX:="test_"

## var nuxt3
BUILD_CONTEXT_NUXT3:="./frontend/"
BIND_VOLUME_NUXT3="`pwd`/frontend/app:/app"

## var nginx
BUILD_CONTEXT_NGINX:="./web/"

# --------------  variables  --------------
ESC=`printf '\033'`
up:
	@make __msg_service_run MESSAGE="$@ from docker-compose.yml"
	@docker-compose up -d
	@echo "\n##containers: "
	@docker ps -a
	@echo "\n##images: "
	@docker images
	@make __msg_service_complete MESSAGE="$@ from docker-compose.yml"
	@echo "\n\n"
	@echo "${ESC}[32mSuccess making up your development env!!"
	@echo "I hope your best developer experience!!"
	@echo "------------------------------------------\n"

setup:
	@make _init-nuxt3 BIND_VOLUME=$(BIND_VOLUME_NUXT3) BUILD_CONTEXT=$(BUILD_CONTEXT_NUXT3)

build-dev:
	@make _build-nuxt3 TARGET="dev" BUILD_CONTEXT=$(BUILD_CONTEXT_NUXT3)
	@make _build-nginx TARGET="dev" BUILD_CONTEXT=$(BUILD_CONTEXT_NGINX)

destroy:
	@docker-compose down
	@make _destroy-nuxt3
	@make _destroy-nginx
	@docker builder prune -f

##	includeはMakefileのみで行っている！
##	複数の.mkファイルで同じファイルをincludeすると重複targetとして警告が出るため
##	とはいえ、どのtargetがどのファイルにあるか分からないため、コメントとして以下、２行のincludeをコメントとして残している
#include ./utils/docker-command.mk
#include ./utils/service-message.mk

##	PRODUCT_PREFIXはMakefileで定義してます
IMAGE_PATTERN_NGINX="$(PRODUCT_PREFIX)nginx*"
CONTAINER_PATTERN_NGINX="$(PRODUCT_PREFIX)nginx"
IMAGE_FAT_NGINX="$(PRODUCT_PREFIX)nginx.fat"
IMAGE_SLIM_NGINX="$(PRODUCT_PREFIX)nginx.slim"

###	ARGS:
###		TARGET: "FROM" image target in Dockerfile. ex. dev | prod etc
###		BUILD_CONTEXT: build context of Dockerfile
_build-nginx:
	@make __build_dockerfile IMAGE_NAME=$(IMAGE_FAT_NGINX) BUILD_CONTEXT=$(BUILD_CONTEXT) TARGET=$(TARGET)
	@make __build_slim IMAGE_NAME_FAT=$(IMAGE_FAT_NGINX)  IMAGE_NAME_SLIM=$(IMAGE_SLIM_NGINX)

_destroy-nginx:
	@make __down_containers CONTAINER_NAME_PATTERN="$(CONTAINER_PATTERN)"
	@make __remove_images IMAGE_PATTERN=$(FOUND_IMAGE_PATTERN_NGINX)
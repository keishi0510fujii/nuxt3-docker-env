##	includeはMakefileのみで行っている！
##	複数の.mkファイルで同じファイルをincludeすると重複targetとして警告が出るため
##	とはいえ、どのtargetがどのファイルにあるか分からないため、コメントとして以下、２行のincludeをコメントとして残している
#include ./utils/docker-command.mk
#include ./utils/service-message.mk

# --------------  variables  --------------
##	PRODUCT_PREFIXはMakefileで定義してます
CONTAINER_NAME_SETUP_NUXT3="$(PRODUCT_PREFIX)nuxt3_setup"
IMAGE_PATTERN_NUXT3="$(PRODUCT_PREFIX)nuxt3*"
CONTAINER_PATTERN_NUXT3="$(PRODUCT_PREFIX)nuxt3"
IMAGE_NAME_SETUP_NUXT3="$(PRODUCT_PREFIX)nuxt3.setup"
IMAGE_FAT_NUXT3="$(PRODUCT_PREFIX)nuxt3.fat"
IMAGE_SLIM_NUXT3="$(PRODUCT_PREFIX)nuxt3.slim"

###	ARGS:
###		TARGET: "FROM" image target in Dockerfile. ex. dev | prod etc
###		BUILD_CONTEXT: build context of Dockerfile
_build-nuxt3:
	@make __msg_service_run MESSAGE="$@ TARGET=$(TARGET) BUILD_CONTEXT=$(BUILD_CONTEXT)"
	@make __build_dockerfile IMAGE_NAME=$(IMAGE_FAT_NUXT3) BUILD_CONTEXT=$(BUILD_CONTEXT) TARGET=$(TARGET)
	@make __build_slim IMAGE_NAME_FAT=$(IMAGE_FAT_NUXT3)  IMAGE_NAME_SLIM=$(IMAGE_SLIM_NUXT3)
	@make __msg_service_complete MESSAGE="$@ TARGET=$(TARGET) BUILD_CONTEXT=$(BUILD_CONTEXT)"

_destroy-nuxt3:
	@make __msg_service_run MESSAGE="$@"
	@make __down_containers CONTAINER_NAME_PATTERN="$(CONTAINER_PATTERN)"
	@make __remove_images IMAGE_PATTERN=$(IMAGE_PATTERN_NUXT3)
	@make __msg_service_complete MESSAGE="$@"

###	ARGS:
###		BIND_VOLUME: bind volume ex. {absolute_path_of_host_directory}:{absolute_path_of_container_directory}
###		BUILD_CONTEXT: build context of Dockerfile
_init-nuxt3:
	@make __msg_service_run MESSAGE="$@ BIND_VOLUME=$(BIND_VOLUME) BUILD_CONTEXT=$(BUILD_CONTEXT)"
#	ホスト側にnode_modulesディレクトリと.nuxtディレクトリを同期するため、セットアップ用のコンテナを起動する
	@make __build_dockerfile IMAGE_NAME=$(IMAGE_NAME_SETUP_NUXT3) BUILD_CONTEXT=$(BUILD_CONTEXT) TARGET="setup"
	@make __run_container CONTAINER_NAME=$(CONTAINER_NAME_SETUP_NUXT3) BIND_VOLUME=$(BIND_VOLUME) BASE_IMAGE=$(IMAGE_NAME_SETUP_NUXT3)
#	ホスト側にnode_modulesと.nuxtディレクトリを生成するためのyarn install
#	docker-compose upでvolumeをbindした時にyarn installされた状態でないとコンテナ起動時にvite serverが起動できないため
	@make __exec_container CONTAINER_NAME=$(CONTAINER_NAME_SETUP_NUXT3) COMMAND="yarn install"
#	一時的に作成しただけなので、コンテナとイメージを削除
	@make __down_containers CONTAINER_PATTERN_NUXT3="$(CONTAINER_NAME_SETUP_NUXT3)"
	@make __remove_images IMAGE_PATTERN=$(IMAGE_NAME_SETUP_NUXT3)
	@make __msg_service_complete MESSAGE="$@ BIND_VOLUME=$(BIND_VOLUME) BUILD_CONTEXT=$(BUILD_CONTEXT)"


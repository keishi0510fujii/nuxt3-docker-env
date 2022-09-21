### ARGS:
###		MESSAGE: string
__msg_command_start:
	@echo "###   start: $(MESSAGE)"

__msg_command_finish:
	@echo "###  finish: $(MESSAGE)"

### ARGS:
###		IMAGE_NAME: image name of -t option ex. nuxt3.fat:latest
###		BUILD_CONTEXT: dockerfile context
###		TARGET: target in dockerfile. ex. dev | setup etc
__build_dockerfile:
	@make __msg_command_start MESSAGE="docker build -t $(IMAGE_NAME) $(BUILD_CONTEXT) --target $(TARGET)"
	@docker build -t $(IMAGE_NAME) $(BUILD_CONTEXT) --target $(TARGET)
	@make __msg_command_finish MESSAGE="docker build -t $(IMAGE_NAME) $(BUILD_CONTEXT) --target $(TARGET)"

### ARGS:
###		IMAGE_NAME_FAT: fat image name
###		IMAGE_NAME_SLIM: slim image name
__build_slim:
	@make __msg_command_start MESSAGE="docker-slim build --target $(IMAGE_NAME_FAT) --http-probe-off --tag $(IMAGE_NAME_SLIM) --exec 'echo '"
# 最後の--exec 'echo 'で無理やりPress Enterを押している　※もっと良いやり方があれば修正したい
	@docker-slim build --target $(IMAGE_NAME_FAT) --http-probe-off --tag $(IMAGE_NAME_SLIM) --exec "echo "
	@make __msg_command_finish MESSAGE="docker-slim build --target $(IMAGE_NAME_FAT) --http-probe-off --tag $(IMAGE_NAME_SLIM) --exec 'echo '"

### ARGS:
###		CONTAINER_NAME: container name. ex. nuxt3_container
###		BIND_VOLUME: bind volume ex. {absolute_path_of_host_directory}:{absolute_path_of_container_directory}
###		BASE_IMAGE: image name or image id
__run_container:
	@make __msg_command_start MESSAGE="docker run --name $(CONTAINER_NAME) -v $(BIND_VOLUME) -itd $(BASE_IMAGE)"
	@docker run --name $(CONTAINER_NAME) -v $(BIND_VOLUME) -itd $(BASE_IMAGE)
	@make __msg_command_finish MESSAGE="docker run --name $(CONTAINER_NAME) -v $(BIND_VOLUME) -itd $(BASE_IMAGE)"

### ARGS:
###		CONTAINER_NAME: container name. ex. nuxt3_container | nginx_container etc
###		COMMAND: docker exec command. ex. yarn | /bin/sh etc
__exec_container:
	@make __msg_command_start MESSAGE="docker exec -it $(CONTAINER_NAME) $(COMMAND)"
	@docker exec -it $(CONTAINER_NAME) $(COMMAND)
	@make __msg_command_finish MESSAGE="docker exec -it $(CONTAINER_NAME) $(COMMAND)"

### ARGS:
###		CONTAINER_NAME_PATTERN: pattern that container name
EXISTS_CONTAINERS=`docker ps -f name="$(CONTAINER_NAME_PATTERN)" -aq`
__down_containers:
	@make __msg_command_start MESSAGE="docker stop $(CONTAINER_NAME_PATTERN) && docker rm --force $(CONTAINER_NAME_PATTERN)"
	@if [ "$(EXISTS_CONTAINERS)" != "" ] ; then \
		docker stop `docker ps -f name="$(CONTAINER_NAME_PATTERN)" -aq`; \
		docker rm --force `docker ps -f name="$(CONTAINER_NAME_PATTERN)" -aq`; \
	else \
		echo "no container that matches $(CONTAINER_NAME_PATTERN)"; \
	fi
	@make __msg_command_finish MESSAGE="docker stop $(CONTAINER_NAME_PATTERN) && docker rm --force $(CONTAINER_NAME_PATTERN)"


### ARGS:
###		IMAGE_PATTERN: included pattern that image name or image id.
EXISTS_IMAGES=`docker images "$(IMAGE_PATTERN)" -q`
__remove_images:
	@make __msg_command_start MESSAGE="docker rmi -f $(IMAGE_PATTERN)"
	@if [ "$(EXISTS_IMAGES)" != "" ] ; then \
		docker rmi -f `docker images "$(IMAGE_PATTERN)" -q`; \
	else \
		echo "no image that matches $(IMAGE_PATTERN)"; \
	fi
	@make __msg_command_finish MESSAGE="docker rmi -f $(IMAGE_PATTERN)"

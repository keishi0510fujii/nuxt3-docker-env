# --------------  show message command templates  --------------
## main commandsで表示するメッセージのテンプレート
### ARGS:
###		MESSAGE: ex. up | build-dev | setup | destroy etc
__msg_service_run:
	@echo "\n\n########################  run: $(MESSAGE)       ########################"

### ARGS:
###		MESSAGE: ex. up | build-dev | setup | destroy etc
__msg_service_complete:
	@echo "########################  complete: $(MESSAGE)  ########################\n\n"

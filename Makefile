######################### 変数の定義 ######################### 

##### Config Files
# Typescript Config
TS_CONFIG = ./tsconfig.json
# npm config
PACKAGE_JSON = ./package.json ./package-lock.json
# Webpack
WEBPACK_DIR = ./webpack
SERVER_WEBPACK_CONF = $(WEBPACK_DIR)/server.js
CLIENT_WEBPACK_CONF = $(WEBPACK_DIR)/client.js
DEV_WEBPACK_CONF = $(WEBPACK_DIR)/dev-server.js

##### node modules
NODE_MODULE_DIR = ./node_modules


##### Client
# ソースコード置き場
CLIENT_SRC_DIR = ./client
# ソースコード、多階層になっているので全て見る
CLIENT_SRC_FILES = $(wildcard $(CLIENT_SRC_DIR)/*) \
          $(wildcard $(CLIENT_SRC_DIR)/*/*) \
          $(wildcard $(CLIENT_SRC_DIR)/*/*/*)


##### Server Source
# ソースコード置き場
SERVER_SRC_DIR = ./server
# ソースコード、多階層になっているので全て見る
SERVER_SRC_FILES = $(wildcard $(SERVER_SRC_DIR)/*) \
          $(wildcard $(SERVER_SRC_DIR)/*/*) \
          $(wildcard $(SERVER_SRC_DIR)/*/*/*)


##### Public
PUBLIC_DIR = ./public
PUBLIC_HTML = $(PUBLIC_DIR)/index.html
PUBLIC_CSS = $(PUBLIC_DIR)/static/style.css


##### Webpackでビルドした後のファイル
DIST_DIR = ./build
DIST_SERVER = $(DIST_DIR)/server.js
DIST_HTML = $(DIST_DIR)/index.html
DIST_STATIC_DIR = $(DIST_DIR)/static
DIST_CLIENT = $(DIST_STATIC_DIR)/client.js
DIST_CSS = $(DIST_STATIC_DIR)/style.css
DIST_FILES = $(wildcard $(DIST_DIR)/*) \
          $(wildcard $(DIST_DIR)/*/*) \
          $(wildcard $(DIST_DIR)/*/*/*)

##### Logs
LOG_DIR = ./.log
NPM_INSTALL_LOG = $(LOG_DIR)/npm-install.log


######################### タスクの定義 ######################### 

##### all
.PHONY: all
all: build

##### 依存関係のインストール
.PHONY: install
install: $(NPM_INSTALL_LOG)
$(NPM_INSTALL_LOG): $(PACKAGE_JSON)
	mkdir -p $(LOG_DIR)
	npm ci | tee $@
	touch $@

##### Bundle with Webpack
.PHONY: build
build: $(DIST_SERVER) $(DIST_CLIENT) $(DIST_HTML) $(DIST_CSS)
# Bundle Server
$(DIST_SERVER): $(TS_CONFIG) $(SERVER_WEBPACK_CONF) $(SERVER_SRC_FILES) $(NPM_INSTALL_LOG)
	npx webpack --config $(SERVER_WEBPACK_CONF)
	touch $(DIST_SERVER)
# Bundle Client
$(DIST_CLIENT): $(TS_CONFIG) $(CLIENT_WEBPACK_CONF) $(CLIENT_SRC_FILES) $(NPM_INSTALL_LOG)
	npx webpack --config $(CLIENT_WEBPACK_CONF)
	touch $(DIST_CLIENT)
$(DIST_HTML) $(DIST_CSS): $(PUBLIC_HTML) $(PUBLIC_CSS)
	cp $(PUBLIC_HTML) $(DIST_HTML)
	cp $(PUBLIC_CSS) $(DIST_CSS)

##### webpackした後のファイルをnodeで実行する
.PHONY: run
run: build
	node $(DIST_SERVER)

.PHONY: start
start: install
	npx webpack-cli serve --config $(DEV_WEBPACK_CONF)

##### serve
.PHONY: serve
serve: build
	mv ./nohup.out $(LOG_DIR)
	nohup node $(DIST_SERVER) &

##### インストールしたNodeモジュールを全て削除
.PHONY: clean
clean:
	rm -rf $(NODE_MODULE_DIR)
	rm $(NPM_INSTALL_LOG)

##### ビルドファイルを全て消去
.PHONY: clear
clear:
	rm -rf $(DIST_DIR)

BUILD_FLAGS := '--production --release'
include .env
export

all: bin/bbb_joiner

docker-build:
	docker-compose build

docker-push: docker-build
	docker-compose push

bin/bbb_joiner: public/main.css
	shards build $(BUILD_FLAGS)

public/main.css: frontend/main.css
	npm run build

watch: watch-backend watch-frontend

docker-watch:
	docker-compose -f docker-compose.dev.yml up --build

watch-backend: bin/sentry public/main.css
	bin/sentry -b 'shards build' -r bin/bbb_joiner -w './src/**/*.cr' -w './src/**/*.ecr' -w './public/**/*'

watch-frontend: node_modules/.bin/parcel
	npm run watch

bin/sentry:
	shards install

node_modules/.bin/parcel:
	npm install

.PHONY: .env all watch docker-watch docker-build docker-push watch-backend watch-frontend bin/bbb_joiner

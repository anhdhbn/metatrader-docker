build:
	docker build -t anhdhbn/metatrader-docker .
push:
	docker push anhdhbn/metatrader-docker:latest
run:
	docker-compose down && docker-compose up --build -d && docker-compose logs -f
exec:
	docker-compose exec app bash

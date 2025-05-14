all: up

up: create_dirs
	@docker compose -f ./srcs/docker-compose.yml up --build -d

create_dirs:
	@sudo rm -rf   /home/$(USER)/data/mariadb
	@sudo mkdir -p /home/$(USER)/data/mariadb
	@sudo chown -R 999:999 /home/$(USER)/data/mariadb
	@sudo install -d -o $(USER) -g $(USER) -m 0755 /home/$(USER)/data/wordpress
	@echo "Created data directories with correct ownership"

down:
	@docker compose -f ./srcs/docker-compose.yml down -v --remove-orphans
	@sudo rm -rf /home/$(USER)/data/

clean: down
	@docker system prune -a --force

fclean: clean
	@sudo rm -rf /home/$(USER)/data
	@docker volume prune --force
	@docker network prune --force
	@echo "Removed all data directories and Docker artifacts"

re: fclean all

.PHONY: all up down clean fclean re create_dirs
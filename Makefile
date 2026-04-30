.PHONY: up check down logs status mysql mysql_sys_temp \
        sakila_dld sakila_restore \
        create_user grant_all show_grants \
        list_users list_tables tables_pks \
        revoke_rights show_grants_after_revoke \
        clean wipe

up:
	docker compose up -d

check:
	docker compose exec -T mysql mysqladmin ping -uroot -proot

down:
	docker compose down

logs:
	docker compose logs -f mysql

status:
	docker compose ps

mysql:
	docker compose exec mysql mysql -uroot -proot

mysql_sys_temp:
	docker compose exec mysql mysql -usys_temp -ppassword

sakila_dld:
	if [ ! -f sakila-db.zip ]; then \
		curl -L -o sakila-db.zip https://downloads.mysql.com/docs/sakila-db.zip; \
	fi

	if [ ! -d sakila-db ]; then \
		unzip -o sakila-db.zip; \
	fi

	ls -la sakila-db/

sakila_restore: sakila_dld
	docker compose exec -T mysql mysql -uroot -proot < sakila-db/sakila-schema.sql

	docker compose exec -T mysql mysql -uroot -proot < sakila-db/sakila-data.sql

	docker compose exec -T mysql mysql -uroot -proot -e "USE sakila; SHOW TABLES;"

create_user:
	docker compose exec -T mysql mysql -uroot -proot < sql/create_user.sql

list_users:
	docker compose exec -T mysql mysql -uroot -proot < sql/list_users.sql

grant_all:
	docker compose exec -T mysql mysql -uroot -proot < sql/grant_all.sql

show_grants:
	docker compose exec -T mysql mysql -uroot -proot < sql/show_grants.sql

list_tables:
	docker compose exec -T mysql mysql -uroot -proot < sql/list_tables.sql

tables_pks:
	docker compose exec -T mysql mysql -uroot -proot < sql/tables_pks.sql

revoke_rights:
	docker compose exec -T mysql mysql -uroot -proot < sql/revoke_rights.sql

show_grants_after_revoke:
	docker compose exec -T mysql mysql -uroot -proot < sql/show_grants_after_revoke.sql

clean:
	rm -rf sakila-db sakila-db.zip

wipe: clean
	docker compose down -v

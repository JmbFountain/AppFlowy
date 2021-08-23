.EXPORT_ALL_VARIABLES:
export DB_USER=postgres
export DB_PASSWORD=password
export DB_NAME=flowy
export DB_PORT=5433
export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}
export ROOT = "./scripts/database"

init_docker:
	${ROOT}/docker.sh

init_database:
	${ROOT}/db_init.sh

reset_db:
	sqlx database reset

add_migrations:
	#make table="the name of your table" add_migrations
	sqlx migrate add $(table)

run_migrations:
	sqlx migrate run

echo_db_url:
	echo ${DATABASE_URL}

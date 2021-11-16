.PHONY: clean

# CHANGE ACCORDINGLY
GCP_PROJECT_ID=____
REGION=us-central1
DB_USER=postgres
DB_PASS=____
DB_NAME=____
CLOUD_SQL_CONNECTION_NAME=____ # eg projectid:us-central1:cloud-sql-name

###############################################################

SERVICE_ID=cloud-run-dart-pg
FUNCTION_TARGET = function
PORT = 8080

# bin/server.dart is the generated target for lib/functions.dart
bin/server.dart:
	dart run build_runner build --delete-conflicting-outputs

build: bin/server.dart

clean:
	dart run build_runner clean
	rm -rf bin/server.dart

run: build
	dart run bin/server.dart --port=$(PORT) --target=$(FUNCTION_TARGET)

deploy:
	gcloud beta run deploy $(SERVICE_ID) --source=. --project=$(GCP_PROJECT_ID) --region=$(REGION) \
		--platform=managed --allow-unauthenticated \
		--add-cloudsql-instances=$(CLOUD_SQL_CONNECTION_NAME) \
		--set-env-vars=DB_USER=$(DB_USER),DB_PASS=$(DB_PASS),DB_NAME=$(DB_NAME),CLOUD_SQL_CONNECTION_NAME=$(CLOUD_SQL_CONNECTION_NAME)

kubectl create secret generic db-sqlserver-secrets --from-literal=SQL_SERVER=sqlserverqft0511.database.windows.net \
						   --from-literal=SQL_PASSWORD=nG4vq6Pc4 \
						   --from-literal=SQL_USER=sqladminqFt0511 \
						   --from-literal=SQL_DBNAME=mydrivingDB

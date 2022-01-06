# TMask_pgbench
Test wydajnościowy postgresa = ok. 1,5 h czas trwania


# Stwórz 3 bazy

### psql -c "CREATE DATABASE bench"
### psql -c "CREATE DATABASE bench1"
### psql -c "CREATE DATABASE bench2"

Skrypt do uruchomienia na serwerze z postgresem. Najlepiej odpalać zdalnie trzeba dodać poświadczenia

# RUN
./tmask_pgbench.sh > LogFile.txt

# oereb-web-service-docker

Use the following env varaibles to setup the service

- DBURL
- DBUSR
- DBPWD
- DBSCHEMA 
- TMPDIR
- MININTERSECTION
- TZ

```
docker run -p8080:8080 -e TZ=Europe/Zurich -e MININTERSECTION=0.1 -e TMPDIR=/tmp -e DBURL=jdbc:postgresql://host.docker.internal:54321/grundstuecksinformation -e DBUSR=gretl -e DBPWD=gretl -e DBSCHEMA=live sogis/oereb-web-service
```


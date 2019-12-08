FROM adoptopenjdk/openjdk8:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends libfontconfig1 curl && rm -rf /var/lib/apt/lists/*

WORKDIR /home/oereb-web-service
COPY build/dist/ /home/oereb-web-service
RUN cd /home/oereb-web-service && \
    chown -R 1001:0 /home/oereb-web-service && \
    chmod -R g+rw /home/oereb-web-service && \
    ls -la /home/oereb-web-service

USER 1001
EXPOSE 8080
CMD java -jar oereb-web-service-docker.jar \
  "--spring.datasource.url=${DBURL}" \
  "--spring.datasource.username=${DBUSR}" \
  "--spring.datasource.password=${DBPWD}" \
  "--oereb.tmpdir=${TMPDIR}" \
  "--oereb.dbschema=${DBSCHEMA}" \
  "--oereb.minIntersection=${MININTERSECTION}" \
  "--oereb.cadastreAuthorityUrl=https://agi.so.ch" \
  "--oereb.planForLandregister=https://geo.so.ch/api/wms?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS=ch.so.agi.grundbuchplan_oereb&STYLES=&SRS=EPSG%3A2056&CRS=EPSG%3A2056&TILED=false&DPI=96&OPACITIES=255&t=675&WIDTH=1920&HEIGHT=710&BBOX=2607051.2375,1228517.0374999999,2608067.2375,1228892.7458333333" \
  "--oereb.planForLandregisterMainPage=https://geo.so.ch/api/wms?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS=ch.so.agi.hintergrundkarte_sw&STYLES=&SRS=EPSG%3A2056&CRS=EPSG%3A2056&TILED=false&DPI=96&OPACITIES=255&t=675&WIDTH=1920&HEIGHT=710&BBOX=2607051.2375,1228517.0374999999,2608067.2375,1228892.7458333333" \
  "--spring.datasource.driver-class-name=org.postgresql.Driver"

HEALTHCHECK --interval=30s --timeout=30s --start-period=60s CMD curl http://localhost:8080/actuator/health
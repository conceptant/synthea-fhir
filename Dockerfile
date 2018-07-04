FROM java:8-jdk-alpine

LABEL maintainer="andrey.mikhalchuk@conceptant.com"
LABEL version="0.0.1.2"
LABEL description="This docker image implements BIND Version 9 and includes basic internet utilities and configuration files for authoritative DNS server."
LABEL "com.conceptant.vendor"="Conceptant, Inc."

COPY files /

ENV SYNTHEA_SEED=
ENV SYNTHEA_SIZE=10
ENV FHIR_URL=

RUN apk update \
    && apk add git curl unzip libstdc++ go \
    && git clone https://github.com/synthetichealth/synthea.git \
    && mv synthea.properties /synthea/src/main/resources/synthea.properties \
    && cd synthea \
    && /gradlew build check test \
    && cd / \
    && git clone https://github.com/synthetichealth/uploader \
    && rm -rf /uploader/vendor/github.com/intervention-engine/fhir/models \
    && git clone https://github.com/intervention-engine/fhir.git -b stu3_mar2017 \
    && cp -r fhir/models /uploader/vendor/github.com/intervention-engine/fhir/ \
    && cd uploader/vendor \
    && ln -s . src \
    && chmod +x /entrypoint.sh

RUN cd /uploader \
    && export GOPATH=/uploader/vendor \
    && go build

VOLUME /synthea/output

CMD ["/entrypoint.sh"]

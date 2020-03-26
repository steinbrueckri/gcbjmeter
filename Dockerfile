FROM alpine:3.11.5

ARG JMETER_VERSION="5.2.1"

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN  ${JMETER_HOME}/bin
ENV MIRROR_HOST http://mirror.synyx.de/apache/jmeter
ENV JMETER_DOWNLOAD_URL ${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL http://repo1.maven.org/maven2/kg/apc
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext/

RUN apk add --no-cache --update ca-certificates \
	&& update-ca-certificates \
	&& apk add --no-cache --update openjdk8-jre tzdata curl unzip bash \
	&& mkdir -p /tmp/jmeter  \
	&& echo "${JMETER_DOWNLOAD_URL}" \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/jmeter/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/jmeter/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/jmeter

RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-dummy/0.2/jmeter-plugins-dummy-0.2.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-dummy-0.2.jar
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-cmn-jmeter/0.5/jmeter-plugins-cmn-jmeter-0.5.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-cmn-jmeter-0.5.jar

ENV PATH $PATH:$JMETER_BIN

COPY launch.sh /

WORKDIR ${JMETER_HOME}

ENTRYPOINT ["/launch.sh"]

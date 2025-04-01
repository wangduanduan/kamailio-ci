FROM alpine:latest AS builder

ARG GIT_BRANCH
ARG GIT_REPO
ARG INCLUDE_MODDULES
ARG DEV_LIBS

RUN apk --no-cache upgrade && apk add --no-cache $DEV_LIBS

RUN mkdir -p /usr/local/src
RUN cd /usr/local/src/ && \
    git clone --depth 1 --branch $GIT_BRANCH $GIT_REPO && \
    cd kamailio && \
    make include_modules="$INCLUDE_MODDULES" cfg && \
    make all && \
    make install

FROM alpine:latest
COPY --from=builder /usr/local/sbin/kamailio /usr/local/sbin/kamailio
COPY --from=builder /usr/local/sbin/kamcmd /usr/local/sbin/kamcmd
COPY --from=builder /usr/local/etc/kamailio /usr/local/etc/kamailio
COPY --from=builder /usr/local/lib64/kamailio /usr/local/lib64/kamailio

RUN kamailio --version
RUN ldd /usr/local/sbin/kamailio
RUN ls /usr/local/lib64/kamailio/modules -lh

ENTRYPOINT ["kamailio", "-DD", "-E"]

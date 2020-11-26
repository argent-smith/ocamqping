FROM ocaml/opam:alpine-ocaml-4.11 as build-app

RUN mkdir -p /home/opam/project
WORKDIR /home/opam/project

RUN opam switch create . 4.11.1+musl+static+flambda

ENV BUILD_STATIC_BINARY=true

COPY --chown=opam . .
RUN eval `opam env` && \
    opam repository set-url default https://opam.ocaml.org && \
    opam update && opam upgrade && \
    opam depext conf-m4 && \
    opam install . -y && \
    opam clean && \
    cp `which amqping` .

FROM busybox:1.32.0 as build-users
RUN addgroup -S amqping \
    && adduser \
       -S \
       -D \
       -H \
       -G amqping \
       amqping

FROM scratch
LABEL maintainer="Pavel Argentov (argentoff@gmail.com)"
COPY --from=build-users /etc/group /etc/group
COPY --from=build-users /etc/passwd /etc/passwd
COPY --from=build-app /home/opam/project/amqping /
USER amqping
ENTRYPOINT ["/amqping"]

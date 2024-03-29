FROM argentoff/opam:4.11.2-musl-static-flambda as build-app

WORKDIR /home/opam/project

ENV BUILD_STATIC_BINARY=true

COPY --chown=opam . .
RUN eval `opam env` && \
    opam repository set-url default https://opam.ocaml.org && \
    opam update && opam upgrade && \
    opam depext conf-m4 && \
    opam install . -y && \
    opam clean && \
    cp `which ocamqping` .

FROM busybox:1.32.0 as build-users
RUN addgroup -S ocamqping \
    && adduser \
       -S \
       -D \
       -H \
       -G ocamqping \
       ocamqping

FROM scratch
LABEL maintainer="Pavel Argentov (argentoff@gmail.com)"
COPY --from=build-users /etc/group /etc/group
COPY --from=build-users /etc/passwd /etc/passwd
COPY --from=build-app /home/opam/project/ocamqping /
USER ocamqping
ENTRYPOINT ["/ocamqping"]

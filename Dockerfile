# First stage of Dockerfile
FROM alpine:latest

ENV PS2DEV /usr/local/ps2dev
ENV PATH   $PATH:${PS2DEV}/ee/bin

COPY . /src

RUN apk add build-base git bash patch wget texinfo
RUN cd /src && ./toolchain.sh

# Second stage of Dockerfile
FROM alpine:latest  

ENV PS2DEV /usr/local/ps2dev
ENV PATH   $PATH:${PS2DEV}/ee/bin

COPY --from=0 ${PS2DEV} ${PS2DEV}

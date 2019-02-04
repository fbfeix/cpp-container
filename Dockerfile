FROM alpine AS build-env

RUN apk --no-cache add cmake clang clang-dev make gcc g++ libc-dev libstdc++ linux-headers git postgresql-libs

ADD . /app
RUN cd /app && mkdir cmake-build-release && cd cmake-build-release

RUN cd /app/cmake-build-release && cmake ../ && make



FROM alpine
RUN apk --no-cache add libstdc++ postgresql-libs
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /app

COPY --from=build-env /app/cmake-build-release/* /app/

# Run the application with name "application_name"
ENTRYPOINT /app/application_name

FROM dart:3.3 AS build

WORKDIR /app

COPY ./app_server/pubspec.* /app/app_server/

WORKDIR /app/app_server
RUN  export PUB_HOSTED_URL='https://pub.dev' && dart pub get

WORKDIR /app
COPY ./app_server/lib /app/app_server/lib
COPY ./app_server/bin /app/app_server/bin
COPY ./app_server/bin/service-account.json /app/app_server/

WORKDIR /app/app_server

RUN dart compile exe bin/main.dart -o bin/server.exe

FROM alpine
COPY --from=build /runtime/ /
COPY --from=build /app/app_server/ /app/app_server/

EXPOSE 8082
WORKDIR /app/app_server/
CMD ["./bin/server.exe"]
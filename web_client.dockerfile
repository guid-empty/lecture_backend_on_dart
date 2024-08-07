FROM ubuntu:18.04 AS build

RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget clang cmake ninja-build pkg-config nodejs npm
ENV TZ="Europe/London"
RUN date

RUN git clone --branch 3.19.2 https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter --version
RUN flutter config --enable-web

RUN mkdir /public/
RUN mkdir /public/web_client
RUN mkdir /app/

COPY ./web_client/pubspec.* /app/web_client/

WORKDIR /app/web_client
RUN flutter pub get

WORKDIR /app
COPY ./web_client/assets /app/web_client/assets
COPY ./web_client/lib /app/web_client/lib
COPY ./web_client/web /app/web_client/web

WORKDIR /app/web_client
ARG WEBSOCKET_SERVER_URL
ARG APP_SERVER_URL

RUN echo $APP_SERVER_URL
RUN echo $WEBSOCKET_SERVER_URL

#   используйте    --release \ для production сборки
RUN export PUB_HOSTED_URL='https://pub.dev' \
    && flutter clean \
    && flutter build web \
    --no-tree-shake-icons \
    --source-maps \
    --dart-define=WEBSOCKET_SERVER_URL="$WEBSOCKET_SERVER_URL" \
    --dart-define=APP_SERVER_URL="$APP_SERVER_URL" \
    --base-href="/"

RUN cp -R ./build/web/* /public/web_client/

FROM alpine
COPY --from=build /app/web_client/build/web /public/web_client

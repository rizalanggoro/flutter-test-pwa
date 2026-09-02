FROM debian:bookworm-slim AS build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates git unzip xz-utils fontconfig && \
    rm -rf /var/lib/apt/lists/*

ARG FLUTTER_VERSION=3.47.2
RUN curl -kfsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" | tar xJ -C /opt && \
    mv /opt/flutter /opt/flutter-sdk
ENV PATH="/opt/flutter-sdk/bin:$PATH"

WORKDIR /app
COPY pubspec.* .
RUN flutter pub get
COPY . .
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

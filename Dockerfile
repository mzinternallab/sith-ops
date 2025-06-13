FROM nginx:stable-alpine
COPY hello-nginx/index.html /usr/share/nginx/html/index.html

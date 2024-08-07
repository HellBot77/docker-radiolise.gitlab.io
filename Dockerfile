FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://gitlab.com/radiolise/radiolise.gitlab.io.git && \
    cd radiolise.gitlab.io && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /radiolise.gitlab.io
COPY --from=base /git/radiolise.gitlab.io .
RUN npm install --global pnpm && \
    pnpm install && \
    export NODE_ENV=production && \
    pnpm build:fullstack

FROM lipanski/docker-static-website

COPY --from=build /radiolise.gitlab.io/packages/radiolise/dist .

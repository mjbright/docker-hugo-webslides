FROM alpine:latest

RUN wget -O hugo_extended.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.70.0/hugo_extended_0.70.0_Linux-64bit.tar.gz && \
    tar xf hugo_extended.tar.gz hugo && \
    rm hugo_extended.tar.gz && \
    mkdir -p /usr/local/bin/ && \
    mv hugo /usr/local/bin/hugo && \
    chmod +x /usr/local/bin/hugo

# Hmm, it seems there's a dependency on libstdc++? else we get
#    "/bin/sh: /usr/local/bin/hugo: not found" errors
# Taken from:
#    https://github.com/jojomi/docker-hugo/blob/master/Dockerfile
RUN     apk add --update git asciidoctor libc6-compat libstdc++ && \
        apk upgrade && \
        apk add --no-cache ca-certificates

# Doesn't copy everything
#ADD     archetypes exampleSite hugo-webslides.sublime-project images layouts static theme.toml \
        #/docker-hugo-webslides/

# Copies everything, use .dockerignore to exclude items
COPY .  /docker-hugo-webslides/

WORKDIR /docker-hugo-webslides/exampleSite

EXPOSE 1313

CMD ["sh", "-c", "/usr/local/bin/hugo serve --bind 0.0.0.0 --themesDir ../.."]



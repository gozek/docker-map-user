# Container image
FROM ubuntu:latest

# Essential CLI build arguements
ARG user
ARG uid
ARG gid

# Set environmental vars
ENV USER=$user USER_ID=$uid USER_GID=$gid

# Add appropriate group inside container
RUN groupadd --gid "${USER_GID}" "${USER}"

# Add appropriate user inside container
RUN useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash \
      ${USER}

# Copy and execute script inside container
COPY mapping.sh /
RUN  chmod u+x mapping.sh

ENTRYPOINT ["/mapping.sh"]

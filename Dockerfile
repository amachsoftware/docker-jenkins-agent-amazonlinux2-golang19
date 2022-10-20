ARG GOLANG_VERSION=1.19

FROM golang:${GOLANG_VERSION} as gosrc
FROM ghcr.io/amachsoftware/jenkins-agent-amazonlinux2


# Switch to root
USER root

# Installing basic packages
RUN apt update && \
    apt install -y zip unzip curl jq && \
    apt clean &&\
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Switch back to the jenkins user to install SDKMAN!

ARG GO_BASE_PATH=/usr/local/go

COPY --from=gosrc ${GO_BASE_PATH} ${GO_BASE_PATH}
COPY --from=gosrc /go ${HOME}

ENV GOPATH=${HOME}
ENV PATH="${GOPATH}/bin:${GO_BASE_PATH}/bin:${PATH}"
ENV CGO_ENABLED=0

USER ${user}

ENTRYPOINT ["jenkins-agent"]
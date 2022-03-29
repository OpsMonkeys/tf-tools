FROM alpine:3.15

ENV TF_1_VERSION=1.1.7
ENV TERRAFORM_LINT_VERSION=0.35.0
ENV TERRAFORM_DOCS_VERSION=0.16.0
ENV TERRAGRUNT_VERSION=0.36.6
ENV INFRACOST_VERSION=0.9.20
ENV KBENV_VERSION=0.3.1
ENV KUBECTL_121_VERSION=1.21.11
ENV KUBECTL_122_VERSION=1.22.7
ENV HELMENV_VERSION=0.3.1
ENV HELM_VERSION=3.7.2

WORKDIR /bin

RUN apk update && \
    apk add --no-cache \
    bash=5.1.16-r0 \
    curl=7.80.0-r0 \
    git=2.34.1-r0 \
    perl-utils=5.34.0-r1 \
    wget=1.21.2-r2 \
    unzip=6.0-r9 \
    tar=1.34-r0 \
    && \
    mkdir ~/.tfenv && \
    git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
    echo "PATH=${HOME}/.tfenv/bin:${PATH}" >> ~/.bashrc && \
    wget -qO terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz && \
    wget -qO terraform-lint.zip https://github.com/terraform-linters/tflint/releases/download/v${TERRAFORM_LINT_VERSION}/tflint_linux_amd64.zip && \
    wget -qO terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    wget -qO infracost-linux-amd64.tar.gz https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz && \
    wget -qO kbenv-linux-amd64.tar.gz https://github.com/little-angry-clouds/kubernetes-binaries-managers/releases/download/${KBENV_VERSION}/kbenv-linux-amd64.tar.gz && \
    wget -qO helmenv-linux-amd64.tar.gz https://github.com/little-angry-clouds/kubernetes-binaries-managers/releases/download/${HELMENV_VERSION}/helmenv-linux-amd64.tar.gz && \
    tar -xzf terraform-docs.tar.gz && \
    tar xzf infracost-linux-amd64.tar.gz && \
    tar xzf kbenv-linux-amd64.tar.gz && \
    tar xzf helmenv-linux-amd64.tar.gz && \
    mv infracost-linux-amd64 infracost && \
    mv helmenv-linux-amd64 helmenv && \
    mv helm-wrapper-linux-amd64 helm && \
    mv kbenv-linux-amd64 kbenv && \
    mv kubectl-wrapper-linux-amd64 kubectl && \
    unzip terraform-lint.zip && \
    rm terraform-lint.zip && \
    rm terraform-docs.tar.gz && \
    rm infracost-linux-amd64.tar.gz && \
    rm kbenv-linux-amd64.tar.gz && \
    rm helmenv-linux-amd64.tar.gz && \
    chmod +x terraform-docs tflint terragrunt infracost kbenv kubectl helmenv helm && \
    . ~/.bashrc && \
    apk del \
    git \
    && \
    rm -rf /var/cache/apk/*

WORKDIR /terraform

COPY entrypoint.sh /entrypoint.sh

RUN . ~/.bashrc && \
    tfenv install ${TF_1_VERSION} && \
    tfenv use ${TF_1_VERSION} && \
    kbenv install ${KUBECTL_121_VERSION} && \
    kbenv install ${KUBECTL_122_VERSION} && \
    kbenv use ${KUBECTL_122_VERSION} && \
    helmenv install ${HELM_VERSION} && \
    helmenv use ${HELM_VERSION}

ENTRYPOINT ["/entrypoint.sh"]


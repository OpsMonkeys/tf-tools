FROM alpine:3.15

ENV TF_15_VERSION=0.15.5
ENV TF_14_VERSION=0.14.11
ENV TF_13_VERSION=0.13.7
ENV TF_12_VERSION=0.12.31
ENV TF_1_VERSION=1.1.5
ENV TERRAFORM_LINT_VERSION=0.34.1
ENV TERRAFORM_DOCS_VERSION=0.16.0
ENV TERRAGRUNT_VERSION=0.36.1

WORKDIR /bin

RUN apk update && \
    apk add --no-cache \
    bash=5.1.8-r0 \
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
    tar -xzf terraform-docs.tar.gz && \
    unzip terraform-lint.zip && \
    rm terraform-lint.zip && \
    rm terraform-docs.tar.gz && \
    chmod +x terraform-docs tflint terragrunt && \
    . ~/.bashrc && \
    apk del \
    git \
    && \
    rm -rf /var/cache/apk/*

WORKDIR /terraform

COPY entrypoint.sh /entrypoint.sh

RUN . ~/.bashrc && tfenv install ${TF_12_VERSION} && tfenv install ${TF_13_VERSION} && tfenv install ${TF_14_VERSION} && tfenv install ${TF_15_VERSION} && tfenv install ${TF_1_VERSION} && tfenv use ${TF_1_VERSION}

ENTRYPOINT ["/entrypoint.sh"]


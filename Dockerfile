FROM alpine:3.15

ENV TF_15_VERSION=0.15.5
ENV TF_14_VERSION=0.14.11
ENV TF_13_VERSION=0.13.7
ENV TF_12_VERSION=0.12.31
ENV TF_1_VERSION=1.0.11
ENV TERRAFORM_LINT_VERSION=0.33.1
ENV TERRAFORM_DOCS_VERSION=0.16.0
ENV TERRAGRUNT_VERSION=0.35.12

WORKDIR /bin

RUN apk update && \
    apk add --no-cache \
    bash \
    curl \
    git \
    perl-utils \
    wget \
    unzip \
    && \
    mkdir ~/.tfenv && \
    git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
    echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
    wget -qO terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 && \
    wget -qO terraform-lint.zip https://github.com/terraform-linters/tflint/releases/download/v${TERRAFORM_LINT_VERSION}/tflint_linux_amd64.zip && \
    wget -qO terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    unzip terraform-lint.zip && \
    rm terraform-lint.zip && \
    chmod +x terraform-docs tflint terragrunt && \
    . ~/.bashrc && \
    apk del \
    git \
    && \
    rm -rf /var/cache/apk/*

WORKDIR /terraform

COPY entrypoint.sh /entrypoint.sh

RUN source ~/.bashrc && tfenv install ${TF_12_VERSION} && tfenv install ${TF_13_VERSION} && tfenv install ${TF_14_VERSION} && tfenv install ${TF_15_VERSION} && tfenv install ${TF_1_VERSION} && tfenv use ${TF_1_VERSION}

ENTRYPOINT ["/entrypoint.sh"]


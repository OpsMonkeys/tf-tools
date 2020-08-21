FROM alpine:3.12.0

ENV TF_13_VERSION=0.13.0
ENV TF_12_VERSION=0.12.29
ENV TERRAFORM_LINT_VERSION=0.15.2
ENV TERRAFORM_DOCS_VERSION=0.9.1
ENV TERRAGRUNT_VERSION=0.23.33

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

ADD entrypoint.sh /entrypoint.sh

RUN source ~/.bashrc && tfenv install ${TF_12_VERSION} && tfenv install ${TF_13_VERSION}

ENTRYPOINT ["/entrypoint.sh"]


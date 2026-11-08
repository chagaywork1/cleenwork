FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# Network + general tools + python
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl wget openssl \
      iputils-ping net-tools iproute2 netcat-openbsd dnsutils traceroute mtr-tiny \
      tcpdump nmap telnet socat whois iperf3 \
      python3 python3-pip python3-venv \
      git openssh-client rsync jq unzip zip less vim nano tree procps lsof htop \
      bash-completion skopeo \
    && rm -rf /var/lib/apt/lists/*

# AWS CLI v2
RUN curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/aws.zip \
 && unzip -q /tmp/aws.zip -d /tmp && /tmp/aws/install && rm -rf /tmp/aws /tmp/aws.zip

# oc + kubectl
RUN curl -fsSL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.16/openshift-client-linux.tar.gz \
    | tar -xz -C /usr/local/bin oc kubectl

# helm, terraform, yq, k9s, argocd
RUN curl -fsSL https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz | tar -xz -C /tmp \
 && mv /tmp/linux-amd64/helm /usr/local/bin/ \
 && curl -fsSL https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip -o /tmp/tf.zip \
 && unzip -q /tmp/tf.zip terraform -d /usr/local/bin \
 && curl -fsSL https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64 -o /usr/local/bin/yq \
 && curl -fsSL https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_Linux_amd64.tar.gz | tar -xz -C /usr/local/bin k9s \
 && curl -fsSL https://github.com/argoproj/argo-cd/releases/download/v2.12.3/argocd-linux-amd64 -o /usr/local/bin/argocd \
 && chmod +x /usr/local/bin/yq /usr/local/bin/argocd \
 && rm -rf /tmp/*

# Python libraries
RUN pip install --no-cache-dir --break-system-packages \
      boto3 requests httpie pyyaml jinja2 kubernetes ansible-core

WORKDIR /root
CMD ["bash"]
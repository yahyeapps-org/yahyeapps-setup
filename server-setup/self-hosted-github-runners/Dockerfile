# Use latest Ubuntu as base
FROM ubuntu:24.04

# Install dependencies and apply security updates
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        jq \
        tar \
        sudo \
        ca-certificates \
        gnupg && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -fsSL https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Create a non-root user for the runner
RUN useradd -m runner
WORKDIR /home/runner

# Download GitHub Actions runner tarball
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.333.1/actions-runner-linux-x64-2.333.1.tar.gz && \
    echo "18f8f68ed1892854ff2ab1bab4fcaa2f5abeedc98093b6cb13638991725cab74  actions-runner.tar.gz" | shasum -a 256 -c - && \
    tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz

# Create work directory for jobs
RUN mkdir -p /home/runner/_work
ENV RUNNER_WORKDIR=/home/runner/_work

# Copy entrypoint script and set permissions
COPY entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh

# Switch to non-root runner user
USER runner

# Run the entrypoint script at container start
ENTRYPOINT ["/home/runner/entrypoint.sh"]
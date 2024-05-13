FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y nasm gcc-multilib

WORKDIR /asmcode

COPY runner.sh /usr/local/bin/runner
COPY problems /problems

RUN chmod +x /usr/local/bin/runner
ENTRYPOINT ["runner"]
CMD ["help"]

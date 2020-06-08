FROM golang@sha256:4d58164df51901679307e547ffed19837e63a1d1b9ed80453b8d88749b6033f4
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

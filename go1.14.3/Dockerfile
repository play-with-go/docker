FROM golang@sha256:1e36f8e9ac49d5ee6d72e969382a698614551a59f4533d5d61590e3deeb543a7
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

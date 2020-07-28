FROM sha256:a794da9351a3b2f860cc9d8859f75c7722ea0eb3d482ceac2c44e20780743018
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bash"]

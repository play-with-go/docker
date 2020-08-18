FROM sha256:75605a4155391abe376fc8124083ec52a2409ceb8a6b5ac6aae7eca133353ce3
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh
RUN chown root:root /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bash"]

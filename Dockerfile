FROM dsavell/grav:admin

RUN rm -rf /tmp && mkdir /tmp && chmod 1777 /tmp
RUN apt-get update && apt-get upgrade -y

ENV DUID=1000 \
    DGID=1000 \
    TZ=America/New_York

COPY grav/user /var/www/grav/user

RUN chown -R www-data:www-data /var/www/grav/user

RUN mkdir -p /var/www/grav/backup /var/www/grav/logs \
    && chown -R www-data:www-data /var/www/grav/backup /var/www/grav/logs

COPY grav-entrypoint.sh /usr/local/bin/grav-entrypoint.sh
RUN chmod +x /usr/local/bin/grav-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/grav-entrypoint.sh"]
CMD ["/init-admin"]

EXPOSE 80

FROM dsavell/grav:admin

# Set environment variables
ENV DUID=1000 \
    DGID=1000 \
    TZ=America/New_York

# Copy your Grav user directory
COPY grav/user /var/www/grav/user

# Set proper permissions
RUN chown -R www-data:www-data /var/www/grav/user

# Create directories for volumes
RUN mkdir -p /var/www/grav/backup /var/www/grav/logs \
    && chown -R www-data:www-data /var/www/grav/backup /var/www/grav/logs

EXPOSE 80

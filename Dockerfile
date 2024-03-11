# Start with the official PHP 8.2 image with Apache
FROM php:8.2-apache

# Install PDO MySQL extension (Laravel requirement)
RUN docker-php-ext-install pdo pdo_mysql

# Copy your Laravel application into the container
COPY . /var/www/html

# Change ownership of the application files to the www-data user and group
# This ensures Apache can read and write to these files as needed
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Set the Apache document root to the public directory of Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Update the Apache configuration to point to the Laravel public directory
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable Apache mod_rewrite for routing
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

---
title: "Installing ruby-3.0.0 on Ubuntu 22.04 using rbenv"
date: "15:22 07/20/2022"
taxonomy:
  category:
    - blog
  tag:
    - ruby
    - ubuntu
    - rbenv
hero_classes: "text-dark title-h1h2 overlay-light hero-large parallax"
hero_image: ruby-lang.png
blog_url: /blog
show_sidebar: false
show_breadcrumbs: true
show_pagination: true
---

For quick reference, you can find the complete installation commands in the [Commands](#commands) section below.

## Background

This guide addresses a specific compatibility issue I encountered between Ruby 3.0.0 and Ubuntu 22.04. The solution involves using [rbenv](https://github.com/rbenv/rbenv), a Ruby version manager, along with a custom OpenSSL configuration.

## The Challenge

When attempting to install Ruby 3.0.0 on Ubuntu 22.04 using rbenv, you might encounter the following error:

```shell
$ rbenv install 3.0.0
Downloading ruby-3.0.0.tar.gz...
-> https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.0.tar.gz
Installing ruby-3.0.0...

BUILD FAILED (Ubuntu 22.04 using ruby-build 20220630)

Inspect or clean up the working tree at /tmp/ruby-build.20220720133848.5660.mjaF0x
Results logged to /tmp/ruby-build.20220720133848.5660.log

Last 10 log lines:
make[2]: Leaving directory '/tmp/ruby-build.20220720133848.5660.mjaF0x/ruby-3.0.0/ext/date'
cc1: note: unrecognized command-line option ‘-Wno-self-assign’ may have been intended to silence earlier diagnostics
cc1: note: unrecognized command-line option ‘-Wno-parentheses-equality’ may have been intended to silence earlier diagnostics
cc1: note: unrecognized command-line option ‘-Wno-constant-logical-operand’ may have been intended to silence earlier diagnostics
linking shared-object socket.so
make[2]: Leaving directory '/tmp/ruby-build.20220720133848.5660.mjaF0x/ruby-3.0.0/ext/socket'
linking shared-object ripper.so
make[2]: Leaving directory '/tmp/ruby-build.20220720133848.5660.mjaF0x/ruby-3.0.0/ext/ripper'
make[1]: Leaving directory '/tmp/ruby-build.20220720133848.5660.mjaF0x/ruby-3.0.0'
make: *** [uncommon.mk:300: build-ext] Error 2
```

## Resolution

The root cause of this issue is an incompatibility between Ruby 3.0.0 and OpenSSL 3.0, which is the default version in Ubuntu 22.04. The solution involves compiling OpenSSL 1.1.1 separately and configuring Ruby to use this version during installation. While upgrading to Ruby 3.1.1 is an alternative solution, the following method allows you to maintain compatibility with Ruby 3.0.0 if required by your project.

### Commands

```shell
# Install required dependencies
sudo apt install build-essential checkinstall zlib1g-dev

# Download OpenSSL 1.1.1p
wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1p.tar.gz

# Extract the archive
tar -xvf openssl-1.1.1p.tar.gz

# Configure and compile OpenSSL
./config --prefix=/opt/openssl-1.1.1q --openssldir=/opt/openssl-1.1.1q shared zlib
make
make test
sudo make install

# Configure SSL certificates
sudo rm -rf /opt/openssl-1.1.1q/certs
sudo ln -s /etc/ssl/certs /opt/openssl-1.1.1q

# Install Ruby 3.0.0 with custom OpenSSL path
RUBY_CONFIGURE_OPTS=--with-openssl-dir=/opt/openssl-1.1.1q rbenv install 3.0.0

# For persistent configuration, add to your .zshrc:
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/openssl-1.1.1q/"
```

This solution provides a reliable way to install Ruby 3.0.0 on Ubuntu 22.04 while maintaining system stability and security. The process primarily involves waiting for the compilation steps to complete, with minimal manual intervention required.

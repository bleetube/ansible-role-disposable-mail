# Ansible Role: disposable-mail

This is an Ansible role that sets up a [mail server](https://wiki.archlinux.org/title/Mail_server) by installing and configuring [postfix](https://www.postfix.org/), [dovecot](https://dovecot.org/), and opendkim.

It is intended to facilitate using smtp and imap service with disposable mail aliases for a single user. It stores mail using Maildir, which is a simple plaintext format. The configuration uses unix sockets for inter-process communication and prefers strong encryption for network connections. The configured [header_checks](files/header_checks) filter out unnecessary postfix mail headers to limit leakage of personal information.

This configuration is not intended to replace a user's primary personal email account. Do not use a disposable alias for important or sensitive accounts. Messages are by default stored in plaintext on your server (unless you've set up disk encryption separately).

It includes a helper script to create new email aliases. You can create an alias to call it.

```shell
alias addmail='ssh root@host create-email-alias'
```
Usage: `addmail newservice` creates an alias to receive mail at newservice@example.com

## Requirements

* Debian/Ubuntu
* [robertdebock.dovecot](https://github.com/robertdebock/ansible-role-dovecot)

See [requirements.yml](requirements.yml)

## Variables

```yaml
postfix_domain: example.com
postfix_hostname: mail.example.com
postfix_smtpd_tls_cert_file: ""
postfix_smtpd_tls_key_file: ""
postfix_smtpd_tls_dh1024_param_file: ""
```

See the [default variables](defaults/main.yml).

## Example Playbook

```yaml
- hosts: mail
  become: yes
  roles:
    - bleetube.disposable-mail
```

## Example Deployment

See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)

## Security

For hardening, we recommend that network access to dovecot (TCP/993) be restricted to trusted IPs. See [cve details](https://www.cvedetails.com/vulnerability-list/vendor_id-6485/Dovecot.html).

## Privacy

Postfix `master.cf` should configure smtpd behavior to require encrypted client connections. In practice, this means figuring out what connection method for a given mail client that is going to work with a mail server that requires strong encryption. 

See [docs/CLIENTS.md](docs/CLIENTS.md) for notes on mail clients.

## Misc

There are some interesting mta implementations that may replace or compliment parts of this stack in the future:
* [simple-nixos-mailserver](https://gitlab.com/simple-nixos-mailserver/nixos-mailserver)
* [maddy](https://github.com/foxcpp/maddy) (go)
* [jmap](https://github.com/stalwartlabs/jmap-server), [vsmtp](https://github.com/viridIT/vSMTP) (rust)
* [roundcube](https://roundcube.net/) (php)

## Credit

Thanks to [Mischa ter Smitten](https://blog.tersmitten.nl) for his work on the [ansible-postfix](https://github.com/Oefenweb/ansible-postfix) role. The postfix setup process is largely a modified version of that role. The relevant license and copyright notice can be found in [postfix.yml](tasks/postfix.yml).
# Mail Server: Deployment

1. Create MX and TXT records

2. Set a password for the "main" virtual inbox:

    ```shell
    echo main:$(doveadm pw -s BLF-CRYPT) >> files/$TARGET/imap.passwd
    ```

3. Copy a vars/targets file, update the values, and run this playbook

    Sanity check opendkim (may need restart):
    ```shell
    l /var/spool/postfix/opendkim/opendkim.sock
    ```

4. look at the maildir uid/gid in main.cf and use those in the imap.passwd file (switching to the dovecot role will fix that later)

5. configure some virtual aliases in /etc/postfix/virtual and run:

    ```shell
    postmap virtual vmailbox
    ```

    See `man 5 postconf` for details.

6. Sanity check: https://mxtoolbox.com/

7. (optional) Create another TXT record for DKIM using the contents of /etc/dkimkeys/mail.txt

    * See [scripts/print-rdata.py](../scripts/print-rdata.py) for an example of how to parse mail.txt
    * See [octodns](https://github.com/octodns/octodns-easydns) and [dnscontrol](https://dnscontrol.org/)


8. (optional) After records propogate, verify outbound mail using: https://www.mail-tester.com/


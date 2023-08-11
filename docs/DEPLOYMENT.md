# Mail Server: Deployment

1. Create MX and TXT records. For example, here are example records defined in dnscontrol:
    ```Javascript
    D('example.com', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
        A('mail', '10.87.129.99'),
        MX('@', 10, 'mail.example.com.'),
        TXT('_dmarc', 'v=DMARC1; p=none'),
        TXT('@', 'v=spf1 mx ~all')
    );
    ```
    The `A` and `MX` records are required, while the `TXT` records are optional but recommended.

2. Set a password for the "main" virtual inbox:

    ```shell
    echo main:$(doveadm pw -s BLF-CRYPT) >> files/$TARGET/imap.passwd
    ```

    Also, if you use `doas` rather than `sudo`, you need to permit your ansible_user to become opendkim in your `/etc/doas.conf`:

    ```
    permit nopass blee as opendkim
    ```

3. Copy a vars/targets file, update the values, and run this playbook

    Troubleshooting: Sanity check opendkim (may need restart, although I think I fixed that):
    ```shell
    ls -AlF /var/spool/postfix/opendkim/opendkim.sock
    ```

4. look at the maildir uid/gid in main.cf and use those in the imap.passwd file (switching to the dovecot role will fix that later)

5. configure some virtual aliases in /etc/postfix/virtual and run:

    ```shell
    postmap virtual vmailbox
    ```

    See `man 5 postconf` for details.

6. Sanity check: https://mxtoolbox.com/

7. (optional) Create another TXT record for DKIM using the contents of /etc/dkimkeys/mail.txt

    Here's an example line in dnscontrol:

    ```Javascript
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANB...QIDAQAB')
    ```

    * See [print-rdata.py](examples/print-rdata.py) for a (kind of bad) example of how to automatically parse mail.txt
    * See [dnscontrol](https://dnscontrol.org/) as well as [octodns](https://github.com/octodns/octodns-easydns) 

    If you're really feeling adventurous, you could even set up a proper dmarc address to replace the original placeholder TXT record.

    ```Javascript
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@satstack.cloud; fo=1')
    ```

    After records propogate, verify outbound mail using [mail-tester](https://www.mail-tester.com/). 


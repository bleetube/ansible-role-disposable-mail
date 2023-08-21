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

2. Configure credentials for the "hello" virtual inbox on the server. Use your favorite password manager to generate a passphrase and then run this to configure it:

    ```shell
    sudo echo hello:$(doveadm pw -s BLF-CRYPT):$(id -u maildir):$(id -g maildir) >> /etc/dovecot/imap.passwd
    ```

    Also, if you use `doas` rather than `sudo`, you need to permit your ansible_user to become opendkim in your `/etc/doas.conf`:

    ```
    permit nopass blee as opendkim
    ```

3. configure some virtual aliases in /etc/postfix/virtual and run: `postmap virtual` (See `man 5 postconf` for details)

4. Configure your playbook's variables and run this playbook.

*   (should be fixed) Troubleshooting: Sanity check opendkim, the unix socket should exist and be writable
    ```shell
    ls -AlF /var/spool/postfix/opendkim/opendkim.sock
    ```

Validate your dns records: [mxtoolbox.com](https://mxtoolbox.com/)

## Optional: sending authenticated mail

* Create another TXT record for DKIM using the contents of /etc/dkimkeys/mail.txt

    Here's an example line in dnscontrol:

    ```Javascript
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANB...QIDAQAB')
    ```

    * See [print-rdata.py](examples/print-rdata.py) for a (kind of bad) example of how to automatically parse mail.txt
    * You can codify your records in a git repo using a tool like [dnscontrol](https://dnscontrol.org/) as well as [octodns](https://github.com/octodns/octodns-easydns) 

* If you're really feeling adventurous, you could even set up a proper dmarc address to replace the original placeholder TXT record.

    ```Javascript
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@satstack.cloud; fo=1')
    ```

After records propogate, verify outbound mail using [mail-tester](https://www.mail-tester.com/). I can score 10/10 by sending an email with an html mime type (just copypasta something from chatgpt).


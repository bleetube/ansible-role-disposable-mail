#!/bin/bash
set -x

TARGET=mail.example.com

mkdir -p $HOME/archive/${TARGET}/{dovecot,postfix}
rsync -tav root@${TARGET}:/etc/dovecot/imap.passwd $HOME/archive/${TARGET}/
rsync -tav root@${TARGET}:/etc/postfix/virtual $HOME/archive/${TARGET}/postfix
rsync -tav root@${TARGET}:/etc/dkimkeys $HOME/archive/${TARGET}/
rsync -tav root@${TARGET}:/var/vmail $HOME/archive/${TARGET}/

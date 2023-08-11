#!/usr/bin/env python3
import zonefile_parser

with open("mail.txt","r") as stream:
    content = stream.read()
    records = zonefile_parser.parse(content)

    for record in records:
        print()
        print(f"{record.name}:")
        print(record.rdata['value'])
        print()


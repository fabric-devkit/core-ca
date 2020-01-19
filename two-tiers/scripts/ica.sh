#!/bin/bash

fabric-ca-client enroll -m admin.root -u http://admin.root:adminpw@ca.root:7054 

fabric-ca-client register --id.name admin.ica \
                          --id.secret adminpw \
                          --id.type client \
                          --id.attrs '"hf.IntermediateCA=true"' \
                          --csr.names C=UK,ST="Tyne and Wear",L="Newcastle upon Tyne",O="Dummy Organisation" \
                          --csr.cn ca.intermediate \
                          -m ca.intermediate \
                          -u http://ca.root:7054

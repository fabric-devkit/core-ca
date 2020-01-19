#!/bin/bash

sqlite3 ./ca-root-home/fabric-ca-server.db "select * from users"
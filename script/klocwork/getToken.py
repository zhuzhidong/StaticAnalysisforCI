#!/usr/bin/env python3
# -*- coding: utf-8 -*-

__author__ = "zhuzhidong"

import os.path


def getToken(host='localhost', port=8080, user='Administrator'):
    ltoken = os.path.normpath(os.path.expanduser("~/.klocwork/ltoken"))
    with open(ltoken, 'r') as ltokenFile:
        for r in ltokenFile.readlines():
            rd = r.strip().split(';')
            if rd[0] == host and rd[1] == str(port) and rd[2] == user:
                return rd[3]


if __name__ == '__main__':
    host = input('Please enter the host name: ')
    port = int(input('Please enter the port number: '))
    user = input('Please enter the user name: ')
    loginToken = getToken(host, port, user)
    if loginToken is not None:
        print("the loginToken of \'%s\' for \"%s:%d\" is %s"
              % (user, host, port, loginToken))
    else:
        print("the loginToken of \'%s\' for \"%s:%d\" does not exist!"
              % (user, host, port))

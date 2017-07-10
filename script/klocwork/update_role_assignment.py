#!/usr/bin/env python3
# -*- coding: utf-8 -*-

__author__ = "zhuzhidong"

import getToken
import urllib.parse
import urllib.request


def update_role_assignment(host, port, user,
                           role_name, account,
                           group=None,
                           project=None,
                           remove=None):
    url = "http://%s:%d/review/api" % (host, port)
    values = {'action': 'update_role_assignment'}
    values['name'] = role_name
    values['account'] = account
    if group is not None:
        values['group'] = group
    if project is not None:
        values['project'] = project
    if remove is not None:
        values['remove'] = remove

    values['user'] = user
    loginToken = getToken.getToken(host, port, user)
    if loginToken is not None:
        values['ltoken'] = loginToken

    data = urllib.parse.urlencode(values)
    # the symbol '-' is invalid in data
    # Klocwork do some thing to bypass it. Klocwork's bug.
    # e.g. Chinese character is represented
    # in unicode(e.g. \u6211) in .conf file
    # and "_" in file path.
    # e.g. "-" is stored as "-" in the .conf file and "_" in file path
    req = urllib.request.Request(url, data.encode())
    urllib.request.urlopen(req)


if __name__ == '__main__':
    print("This module can only be imported into other modules!")

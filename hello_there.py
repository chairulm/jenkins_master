#!/usr/bin/env python3

from flask import Flask

@app.route('/')
def hello():
    return 'Hello, There!'

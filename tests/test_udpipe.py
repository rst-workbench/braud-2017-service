#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Author: Arne Neumann <rst-workbench.programming@arne.cl>

from pathlib import Path
import pexpect
import pytest
import requests


def test_uppipe_api():
    """A plaintext file can be parsed with UDPIPE 1 via its REST API."""
    input_text = Path('tests/fixtures/input_eurostar.txt').read_text()

    res = requests.post(
        '{}/process'.format('http://localhost:9090'),
        data={'tokenizer': '', 'tagger': '', 'parser': ''},
        files={'data': input_text})

    udpipe_output = res.json()['result']
    expected_udpipe_output = Path('tests/fixtures/input_eurostar.txt.conllu').read_text()
    assert udpipe_output == expected_udpipe_output
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Author: Arne Neumann <rst-workbench.programming@arne.cl>

import os
from pathlib import Path
import pexpect
import pytest
import requests


UDPIPE1_ENDPOINT = os.environ.get('UDPIPE1_ENDPOINT', 'http://localhost:9090')
ENGLISH_MODEL = 'english-ewt-ud-2.5-191206.udpipe'
GERMAN_MODEL = 'german-hdt-ud-2.5-191206.udpipe'


def test_available_models():
    """UDPIPE API serves the expected English and German models."""
    res = requests.get(f'{UDPIPE1_ENDPOINT}/models')
    res_dict = res.json()
    assert ENGLISH_MODEL in res_dict['models']
    assert GERMAN_MODEL in res_dict['models']

    # UDPIPE defaults to English
    assert ENGLISH_MODEL == res_dict['default_model']


def test_uppipe_api_english():
    """A plaintext file can be parsed with UDPIPE 1 via its REST API."""
    input_text = Path('tests/fixtures/input_eurostar_en.txt').read_text()

    res = requests.post(
        '{}/process'.format(UDPIPE1_ENDPOINT),
        data={'model': ENGLISH_MODEL, 'tokenizer': '', 'tagger': '', 'parser': ''},
        files={'data': input_text})

    udpipe_output = res.json()['result']
    expected_udpipe_output = Path('tests/fixtures/input_eurostar_en.txt.conllu').read_text()
    assert udpipe_output == expected_udpipe_output

def test_uppipe_api_german():
    """A plaintext file can be parsed with UDPIPE 1 via its REST API."""
    input_text = Path('tests/fixtures/input_eurostar_de.txt').read_text()

    res = requests.post(
        '{}/process'.format(UDPIPE1_ENDPOINT),
        data={'model': GERMAN_MODEL, 'tokenizer': '', 'tagger': '', 'parser': ''},
        files={'data': input_text})

    udpipe_output = res.json()['result']
    expected_udpipe_output = Path('tests/fixtures/input_eurostar_de.txt.conllu').read_text()
    assert udpipe_output == expected_udpipe_output

#!/usr/bin/env python
"""
A multiple times hacked up version of the multiple-Python checkers
script from EmacsWiki.

 - Simplified & faster
 - Extended with pep8.py
 - Extended with pydo (http://www.lunaryorn.de/code/pydo.html)
 - pylint & pychecker removed
 Changes by Daniel Molina Wegener <dmw@coder.cl>:
 - Extended with pychecker again
 - Added error ignore on the message processing routine
 - Default checkers now are pep8, pyflakes, pylint and pychecker

Drop something like this in your .emacs:

(when (load "flymake" t)
  (defun flymake-pycheckers-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "/path/to/this/file" (list local-file))))

You may also need to set up your path up in the __main__ function at the
bottom of the file and change the #! line above to an appropriate interpreter.

==============================================================================

This code is made available by Jason Kirtland <jek@discorporate.us> under the
Creative Commons Share Alike 1.0 license:
http://creativecommons.org/licenses/sa/1.0/

Original work taken from http://www.emacswiki.org/emacs/PythonMode, author
unknown.

"""

## Customization ##

# Checkers to run be default, when no --checkers options are supplied.
# One or more of pydo, pep8 or pyflakes, separated by commas
DEFAULT_CHECKERS = 'pep8,pyflakes,pylint,pychecker'

# A list of error codes to ignore.
# DEFAULT_IGNORE_CODES = ['E225', 'W114']
DEFAULT_IGNORE_CODES = []

## End of customization ##

import os
from os import path
import re
import sys

from subprocess import Popen, PIPE


class LintRunner(object):
    """Base class provides common functionality to run python code checkers."""

    output_format = ("%(level)s %(error_type)s%(error_number)s:"
                     "%(description)s at %(filename)s line %(line_number)s.")

    output_template = dict.fromkeys(
        ('level', 'error_type', 'error_number', 'description',
         'filename', 'line_number'), '')

    output_matcher = None

    sane_default_ignore_codes = set([])

    command = None

    line = None

    run_flags = ()

    def __init__(self, ignore_codes=(), use_sane_defaults=True):
        self.ignore_codes = set(ignore_codes)
        if use_sane_defaults:
            self.ignore_codes ^= self.sane_default_ignore_codes

    def fixup_data(self, line, data):
        """ Fixes data for missing elements """
        self.line = line
        return data

    def process_output(self, line):
        """ Process output chcker output """
        matcher = self.output_matcher.match(line)
        if matcher:
            return matcher.groupdict()

    def run(self, filename):
        """ Run the checker over the file """
        args_ = [self.command]
        args_.extend(self.run_flags)
        args_.append(filename)

        process = Popen(args_, stdout=PIPE, stderr=PIPE)

        for line in process.stdout:
            match = self.process_output(line)
            if match and not 'error_number_alt' in match:
                match['error_number_alt'] = False
            if match and not 'error_number' in match:
                match['error_number'] = False
            if match \
               and not match['error_number'] in DEFAULT_IGNORE_CODES \
               and not match['error_number_alt'] in DEFAULT_IGNORE_CODES:
                tokens = dict(self.output_template)
                tokens.update(self.fixup_data(line, match))
                print self.output_format % tokens

        for line in process.stderr:
            if match and not 'error_number' in match:
                match['error_number'] = False
            if match and not 'error_number_alt' in match:
                match['error_number_alt'] = False
            if match \
               and not match['error_number'] in DEFAULT_IGNORE_CODES \
               and not match['error_number_alt'] in DEFAULT_IGNORE_CODES:
                tokens = dict(self.output_template)
                tokens.update(self.fixup_data(line, match))
                print self.output_format % tokens


class PyFlakesRunner(LintRunner):
    """Run pyflakes, producing flymake readable output.

    The raw output looks like:
      tests/test_richtypes.py:4: 'doom' imported but unused
      tests/test_richtypes.py:33: undefined name 'undefined'
    or:
      tests/test_richtypes.py:40: could not compile
             deth
            ^
    """

    command = 'pyflakes'

    output_matcher = re.compile(
        r'(?P<filename>[^:]+):'
        r'(?P<line_number>[^:]+):'
        r'(?P<description>.+)$')

    def fixup_data(self, line, data):
        if 'imported but unused' in data['description']:
            data['level'] = 'WARNING'
        elif 'redefinition of unused' in data['description']:
            data['level'] = 'WARNING'
        else:
            data['level'] = 'ERROR'
        data['error_type'] = 'PY'
        data['error_number'] = 'F01'
        return data


class PyCheckerRunner(LintRunner):
    """Run pychecker, producing flymake readable output.

    The raw output looks like:
      tests/test_richtypes.py:4: 'doom' imported but unused
      tests/test_richtypes.py:33: undefined name 'undefined'
    or:
      tests/test_richtypes.py:40: could not compile
             deth
            ^
    """

    command = 'pychecker'

    output_matcher = re.compile(
        r'(?P<filename>[^:]+):'
        r'(?P<line_number>[^:]+): '
        r'(?P<description>.+)$')

    def fixup_data(self, line, data):
        data['level'] = 'WARNING'
        data['error_type'] = 'PY'
        data['error_number'] = 'C01'
        if 'filename' in data:
            filename = data['filename']
            filename = filename.replace("[system path]/", "")
            data['filename'] = filename
        return data


class PyLintRunner(LintRunner):
    """Run pyflakes, producing flymake readable output.

    The raw output looks like:
      tests/test_richtypes.py:4: 'doom' imported but unused
      tests/test_richtypes.py:33: undefined name 'undefined'
    or:
      tests/test_richtypes.py:40: could not compile
             deth
            ^
    """
    command = 'pylint'

    output_matcher = re.compile(
        r'(?P<filename>[^:]+):'
        r'(?P<line_number>[^:]+):'
        r' \[(((?P<error_number>.+), '
        r'(?P<error_where>.+))|(?P<error_number_alt>.+))\] '
        r'(?P<description>.+)$')

    def fixup_data(self, line, data):
        if 'error_number_alt' in data \
               and data['error_number_alt'] \
               and len(data['error_number_alt']) > 0:
            data['error_number'] = data['error_number_alt']
        data['level'] = 'WARNING'
        return data

    @property
    def run_flags(self):
        """ Returns the run flags for the checker """
        return ['--output-format=parseable',
                '--reports=no',
                '--ignore=' + ','.join(self.ignore_codes)]


class PEP8Runner(LintRunner):
    """Run pep8.py, producing flymake readable output.

    The raw output looks like:
      spiders/structs.py:3:80: E501 line too long (80 characters)
      spiders/structs.py:7:1: W291 trailing whitespace
      spiders/structs.py:25:33: W602 deprecated form of raising exception
      spiders/structs.py:51:9: E301 expected 1 blank line, found 0

    """

    command = 'pep8'

    output_matcher = re.compile(
        r'(?P<filename>[^:]+):'
        r'(?P<line_number>[^:]+):'
        r'[^:]+:'
        r' (?P<error_number>\w+) '
        r'(?P<description>.+)$')

    def fixup_data(self, line, data):
        data['level'] = 'WARNING'
        return data

    @property
    def run_flags(self):
        """ Returns the run flags for the checker """
        return '--repeat', '--ignore=' + ','.join(self.ignore_codes)


class PyDoRunner(LintRunner):
    """Run pydo, producing flymake readable output.

    The raw output looks like:
      users.py:470:todo:rtf memcache this possibly?
    """

    command = 'pydo'

    output_matcher = re.compile(
        r'(?P<filename>[^:]+):'
        r'(?P<line_number>[^:]+):'
        r'(?P<error_number>\w+)'
        r'(\W*|\s*)'
        r'(?P<description>.*)$')

    def fixup_data(self, line, data):
        return data


def croak(*msgs):
    """ Croacks the output """
    for msg in msgs:
        print >> sys.stderr, msg.strip()
    sys.exit(1)


RUNNERS = {'pyflakes': PyFlakesRunner,
           'pep8': PEP8Runner,
           'pydo': PyDoRunner,
           'pylint': PyLintRunner,
           'pychecker': PyCheckerRunner}


if __name__ == '__main__':
    # transparently add a virtualenv to the path when launched with a venv'd
    # python.
    os.environ['PATH'] = \
      path.dirname(sys.executable) + ':' + os.environ['PATH']

    if len(sys.argv) < 2:
        croak("Usage: %s [file]" % sys.argv[0])
    elif len(sys.argv) > 2:
        from optparse import OptionParser
        parser = OptionParser()
        parser.add_option("-i", "--IGNORE_CODES", dest="IGNORE_CODES",
                          default=[], action='append',
                          help="error codes to ignore")
        parser.add_option("-c", "--checkers", dest="checkers",
                          default='pep8,pyflakes,pylint,pychecker',
                          help="comma separated list of checkers")
        options, args = parser.parse_args()
        if not args:
            croak("Usage: %s [file]" % sys.argv[0])
        if options.checkers:
            checkers = options.checkers
        else:
            checkers = DEFAULT_CHECKERS
        if options.IGNORE_CODES:
            IGNORE_CODES = options.IGNORE_CODES
        else:
            IGNORE_CODES = DEFAULT_IGNORE_CODES
        source_file = args[0]
    else:
        source_file = sys.argv[1]
        checkers = DEFAULT_CHECKERS
        IGNORE_CODES = DEFAULT_IGNORE_CODES

    for checker in checkers.split(','):
        try:
            print(u"using -> %s" % (checker.strip()))
            klass = RUNNERS[checker.strip()]
        except KeyError:
            croak(("Unknown checker %s" % checker),
                  ("Expected one of %s" % ', '.join(RUNNERS.keys())))
        runner = klass(ignore_codes=IGNORE_CODES)
        runner.run(source_file)

    sys.exit(0)

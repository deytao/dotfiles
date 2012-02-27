#!/usr/bin/env python
"""
  Scan php files and refactor each lines.

  Strip trailing spaces
  from: include dirname(__FILE__) . '/test.inc';
  to: include dirname(__FILE__) . '/' . basename(__FILE__, '.php') . '.inc';
"""

from __future__ import with_statement

import fileinput
import functools
import os
import re
import sys


eol_pattern = re.compile('[ \t]*\n')
strip_trailing_spaces = functools.partial(eol_pattern.sub, '\n')


def process_file(filepath):
    """Remove trailing spaces and refactor include statement."""
    basename, ext = os.path.splitext(os.path.basename(filepath))
    filepath_new = filepath + '.new'
    with open(filepath_new, 'w') as fd_out:
        with open(filepath, 'r') as fd_in:
            for line in fd_in:
                line = line.replace(basename + '.inc\'', 
                    "' . basename(__FILE__, '.php') . '.inc'")
                fd_out.write(line)
    os.rename(filepath_new, filepath)


def process_files(basedir):
    """Process php files in a directory recursively."""
    for path, dirnames, filenames in os.walk(basedir):
        for filename in filenames:
            if not filename.endswith('.php'):
                continue
            filepath = os.path.join(path, filename)
            process_file(filepath)


def main():
    try:
        basedir = sys.argv[1]
    except IndexError:
        basedir = os.curdir
    process_files(basedir)


if __name__ == '__main__':
    main()

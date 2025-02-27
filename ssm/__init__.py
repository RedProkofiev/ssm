"""
   Copyright (C) 2012 STFC.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   @author: Will Rogers
"""

import logging
import sys

__version__ = (3, 3, 1)

LOG_BREAK = '========================================'


def set_up_logging(logfile, level, console):
    """Programmatically initialise logging system."""
    levels = {'DEBUG': logging.DEBUG,
              'INFO': logging.INFO,
              'WARN': logging.WARN,
              'ERROR': logging.ERROR,
              'CRITICAL': logging.CRITICAL}

    fmt = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    formatter = logging.Formatter(fmt)

    log = logging.getLogger()
    log.setLevel(levels[level])

    if logfile is not None:
        fh = logging.FileHandler(logfile)
        fh.setFormatter(formatter)
        log.addHandler(fh)

    if console:
        ch = logging.StreamHandler(sys.stdout)
        ch.setFormatter(formatter)
        log.addHandler(ch)

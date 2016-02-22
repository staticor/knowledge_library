# coding: utf-8


import logging

# first to know about logging < level and warning>
# logging.warning('Watch out') # print a message to the console
# logging.info('I told you so') # not print anything

# why it not appear?
# ==> the default level is WARNING
#

# logging to a file
logging.basicConfig(filename='example.log', format='%(asctime)s  %(levelname)s:%(message)s', level=logging.DEBUG)
logging.debug('This message should go to the log file')
logging.info('So should this')
logging.warning('And this, too')

# level=logging.DEBUG: 所有level都将被输出






# logFormatter = logging.Formatter("%(asctime)s [%(threadName)-12.12s] [%(levelname)-5.5s] %(message)s")

# rootLogger = logging.getLogger()

# fileHandler = logging.FileHandler("{0}/{1}.log".format(logPath, fileName))

# fileHandler.setFormatter(logFormatter)
# rootLogger.addHandler(fileHandler)

# consoleHandler = logging.StreamHandler()
# consoleHandler.setFormatter(logFormatter)
# rootLogger.addHandler(consoleHandler)

# coding: utf-8


import logging

# logging to a file
logging.basicConfig(filename='example.log', format='%(asctime)s  %(levelname)s:%(message)s', level=logging.DEBUG)

logging.debug('========================BEGIN========================')

logging.info('So should this')


#
logging.debug('========================END========================')



#!/usr/bin/python

import os
import sys
import csv

filelist = filter(lambda x: '.log' in x, os.listdir('.'))
data = {}
processed = {}
for f in filelist:
    processed[f]={}
    data[f]={}
    infile = csv.reader(file (f,'r'), delimiter=';')
    for test in ('read_4k_1', 'write_4k_1', 'read_4k_32', 'write_4k_32', 'read_256k_32', 'write_256k_32'):
        data[f][test]=infile.next()
    processed[f]['read_4k_1_IOPS'] = data[f]['read_4k_1'][7]
    processed[f]['read_4k_32_IOPS'] = data[f]['read_4k_32'][7]

    processed[f]['write_4k_1_IOPS'] = data[f]['write_4k_1'][48]
    processed[f]['write_4k_32_IOPS'] = data[f]['write_4k_32'][48]

    processed[f]['read_max_bw'] = data[f]['read_256k_32'][6]
    processed[f]['write_max_bw'] = data[f]['write_256k_32'][47]

    processed[f]['read_mean_lat'] = data[f]['read_4k_1'][15]
    processed[f]['write_mean_lat'] = data[f]['write_4k_1'][56]

oplist=['read_4k_1_IOPS', 'write_4k_1_IOPS', 'read_4k_32_IOPS', 'write_4k_32_IOPS', 'read_max_bw', 'write_max_bw', 'read_mean_lat', 'write_mean_lat']
print ','.join(['test_name']+oplist)

for e in processed:
    print ','.join([e]+[processed[e][d] for d in oplist])

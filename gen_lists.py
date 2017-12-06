#!/usr/bin/env python

import argparse
import collections
import os

parser = argparse.ArgumentParser(description='Create file lists base on file name')
parser.add_argument('arguments', help='list of arguments', type=str, nargs='+')
parser.add_argument('-s', '--separator', help='file name separator', type=str, default='_seed_')
parser.add_argument('-o', '--output', help='output dir', type=str, default='.')

args = parser.parse_args()

flist = collections.defaultdict(list)

for i in args.arguments:
    p,f = os.path.split(i)
    parts = f.split(args.separator)

    flist[parts[0]].append(os.path.abspath(i))

for k,v in flist.items():
    l = len(v)
    fn = "{:s}/{:s}_{:d}.lst".format(args.output, k, l)

    with open(fn, 'w') as f:
        for e in v:
            f.write(e + '\n')
    f.close()

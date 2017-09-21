#!/usr/bin/env python3
import csv
import json
import sys

csvfile = open('data.csv', 'r')

fieldnames = ("code", "city", "land")
reader = csv.DictReader( csvfile, fieldnames)
json.dump({r['code']: ", ".join([r['city'], r['land']]) for r in reader}, sys.stdout)

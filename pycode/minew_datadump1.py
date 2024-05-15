# -*- coding: utf-8 -*-
# Hankun Li, Jan 21 2021


import os
from time import time, sleep
from collections import OrderedDict
import json


class minewDataDump(object):

    def __init__(self, filename):
        self.fname = filename

    def file_read(self):
        f = open(self.fname, 'r')
        lines = f.readlines()
        f.close()
        if not lines:
            print('empty input file\n')
            exit(0)
        return lines
   
    def getGW_info(self, line:str) -> list:
        line = line.strip('\n')[1:-1]
        for k in range(len(line)):
            if line[k] == ',' and line[k+1] == '{' and line[k-1] == '}':
                break
        try:
            gw = json.loads(line[0:k])
        except Exception as err:
            print("WARNING: ", err)
            gw = json.loads(line)
        return [gw['mac'], gw['timestamp'][:-5]]

    def getSS_info(self, lines:list) -> dict:
        rssi = OrderedDict()
        for line in lines:
            queue = line.strip('\n')[1:-1].split('},{')
            for info in queue:
                if info[0] != '{':
                    info = '{' + info
                if info[-1] != '}':
                    info = info + '}'
                info = json.loads(info)
                if info['type'] == 'Gateway':
                    continue
                if info['type'] == 'iBeacon':
                    dkey = info['timestamp'][:-5]
                    if dkey in rssi:
                        rssi[dkey].append([info['mac'],info['rssi']])
                    else:
                        rssi[dkey] = [[info['mac'],info['rssi']]]
                else:
                    print('data error!\n')
                    exit(0)
        return rssi

    def writeData(self, datas:dict, gwinfo):
        timestamp = gwinfo[1].replace('-','_')
        out_name = 'sorted_' + gwinfo[0] + '_' + timestamp.replace(':','_') + '.txt'
        ssname = OrderedDict()
        wcache = '' #small txt file is fine (ram is ok)
        for tm in datas:
            line = tm
            for ss in datas[tm]:
                dtmp = ssname
                if ss[0] not in ssname:
                    ssname[ss[0]] = ''
                    dtmp[ss[0]] = ss[1]
                else:
                    dtmp[ss[0]] = ss[1]
            for item in dtmp:
                line = line + '\t' + item + '\t' +str(dtmp[item])
            wcache = wcache + line + '\n'
        f = open (out_name,'w')
        f.write(wcache)
        f.close()
   
if __name__ == "__main__":

    filename = fn + '.txt'
    mdd = minewDataDump(filename)
    rdata = mdd.file_read()
    GW = mdd.getGW_info(rdata[0])
    rssi_sorted = mdd.getSS_info(rdata)
    mdd.writeData(rssi_sorted, GW)

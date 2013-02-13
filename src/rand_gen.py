'''
    @Author shane moore
    Team Van-Rossum
    

    Python script to call acl2

'''


import logging
import os
import json
import random as rand

LOG = '/home/shane/se2/logs'




def find_longest(words):
    longest = ''
    for word in words:
        longest = word
        if len(longest) < len(word):
            longest = word
    return longest



def mtx_size(words):
    

    
    l_wrd = find_largest(len(words))
    
    

def parse_json(data):
    data = data.split('\n')
    row_dict = {}
    for i in range(1,data):
        row_dict[i] = data[i]
        
    with open('rows.json','w') as fd:
        fd.write(json.dumps(row_dict))


def main():

    words = []
    with open('words') as fd:
        
        words = fd.read().split('\n')

    
    mtx_size = mtx_size(len(words), mx_wrd)
    


    with open('rands', 'w') as fd:
        rands = []
        for i in range(0,mtx_size):
            rands.append(random.randint(1,3000))
            fd.write(rands)

    
    pid = os.fork()
    
    if pid == 0:
        os.system('acl2 create-board.el')
    else:
        os.waitpid(5)
        
    with open(output.txt, 'r') as fd:
        fd.read()
        
             
        
        

    
if __name__ == '__main__':
    main()


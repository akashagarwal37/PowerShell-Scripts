import json
with open('file1.json','r') as f:
    data=f.readlines()
    print(data)
    for i in range(len(data)):
        data1=data[i].split()
        for j in data1:
            print(j)
            
        
    #x={'Country2':'UK'}
    #json.dump(x,f)

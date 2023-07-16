# -*- coding: utf-8 -*-
"""
Created on Tue Mar 14 08:35:17 2023

@author: msenturk
"""
import json
import matplotlib.pyplot as plt

country_names = ["Brazil", "Global", "Germany", "Italy", "Japan", "SouthKorea"] #, "Poland", "Turkey"]


country_datas =  []

def getCountryData(country_name, data_holder):
    f = open( f"results_08012023/Data/27012023_{country_name}_shortOptimized_x0_c_L.txt","r")
    dat = f.read()
    dat = "{" + dat + "}"
    params = json.loads(dat)
    country = {}
    country['triangle'] = params
    x0 = params['x0']
    L = params['L']
    c = params['C']
    H = 2
    Y = []
    
    X = range(x0 + L + 1)
    for i in range(x0+1):
        print(i)
        Y.append(0);
        
    for i in range(1, c+1):
        print(i)
        h = (i/c)*H
        Y.append(h)
    
    for i in range(1, (L-c)+1):
        print(i)
        h = H - (i/(L-c))*H
        Y.append(h)
    country['data'] = Y
    country['name'] = country_name
    data_holder.append(country)

countries = []
for country_name in country_names:
    print(country_name)
    getCountryData(country_name, countries)
    
fig, ax = plt.subplots()
plt.plot(countries[0]['data'], '-r', linewidth=1)
plt.plot(countries[1]['data'], '-g', linewidth=1)
plt.plot(countries[2]['data'], '-b', linewidth=1)
plt.plot(countries[3]['data'], '-c', linewidth=1)
plt.plot(countries[4]['data'], '-m', linewidth=1)
plt.plot(countries[5]['data'], '-y', linewidth=1)


ratio = 0.3
x_left, x_right = ax.get_xlim()
y_low, y_high = ax.get_ylim()
ax.set_aspect(abs((x_right-x_left)/(y_low-y_high))*ratio)

plt.legend(country_names, fontsize='x-small')
plt.xlabel("Day")
plt.ylabel("Number of Cases")
plt.savefig("triangles_shortOptimized", dpi=1080, bbox_inches="tight", fontsize=8)
plt.close()
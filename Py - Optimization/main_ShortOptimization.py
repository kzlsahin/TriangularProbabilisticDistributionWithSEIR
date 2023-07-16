#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 13 16:18:36 2021

@author: kzlsahin
"""
import sys
import json
import numpy as np
import pandas as pd
import math as math
import TriangularDistribution as td

country_names = ["Brazil", "Global", "Germany", "Italy", "Japan", "SouthKorea"] #, "Poland", "Turkey"]
    
def runByCountryName(country_name, prefix = "", suffix=""):
    data = {}
    with open( f"data/{prefix}_" + country_name + ".txt","r") as f:
        data = json.load(f)
        f.close()

    DailyRecovered = np.nan_to_num(np.array(data["DailyRecovered"]).astype(float))
    DailyCases = np.nan_to_num(np.array(data["DailyCases"]).astype(float))
    death_rate = data["DeathRate"]

    DailyRecovered = pd.DataFrame(DailyRecovered[:423]).rolling(7).sum()/7
    DailyRecovered = np.nan_to_num(DailyRecovered .to_numpy().flatten())
    
    DailyCases = pd.DataFrame(DailyCases[:423]).rolling(7).sum()/7
    DailyCases = np.nan_to_num(DailyCases.to_numpy().flatten())
    
    boundaries = {'x0':(1,10), 'c':(1, 10), 'L': (11, 41)}
    res = td.optimizeByGenetic(DailyCases, DailyRecovered, boundaries, death_rate,  max_generation=6)
    
    
    
    params = {
    'x0' : res['bestGenotype'][0].astype(int),
    'C' : res['bestGenotype'][1].astype(int),
    'L' : res['bestGenotype'][2].astype(int),
    }

    distributionResult = td.createDistributionArray(DailyCases, death_rate, X0=params['x0'], L=params['L'], C=params['C'])
    distArr_trimmed = np.array( distributionResult[:len(DailyRecovered)] )
    
    MSE = math.sqrt(np.square(distArr_trimmed - DailyRecovered).mean())
    text_to_write = f"\"x0\" : {params['x0']}, \"L\": {params['L']} ,\"C\" : {params['C']} "
    with open( f"data/{prefix}_" + country_name + f"_{suffix}_x0_c_L.txt","w") as f:
        f.write(text_to_write )
        f.close()

    with open("results_08012023/OptimizationResults/" + country_name + f"_{suffix}_Fittneses.txt", "w") as fout:
        fout.write(json.dumps(res['hist']['fitness']))
        
    original_stdout = sys.stdout
    with open("results_08012023/OptimizationResults/" + country_name + f"_{suffix}_Results.txt", "w") as fout:
        sys.stdout = fout
        print(f"MSE : {MSE}")
        print(res, fout)
        sys.stdout = original_stdout

    print(f"best fit genotype: X0: {params['x0']}, C: {params['C']}, L: {params['L']}")
    print(f"MSE for this genotype: {MSE}")

    
    return res


#runByCountryName("SKorea", prefix="27012023", suffix = "shortOptimized")

for name in country_names:
    runByCountryName(name, prefix="27012023", suffix = "shortOptimized")

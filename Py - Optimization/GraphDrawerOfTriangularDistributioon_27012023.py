# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 13:35:31 2023

@author: deniz
"""

import sys
import json
import numpy as np
import math
import pandas as pd
import matplotlib.pyplot as plt
import TriangularDistribution as td


print("running...")

country_names = ["Brazil", "Global", "Germany", "Italy", "Japan", "Poland", "Turkey", "SouthKorea"]
swl = 4 #smoothing window length

def GetXLC(inp):
    dat = "{" + inp + "}"
    res = json.loads(dat)
    return res

def runByCountryName(country_name, params = None, prefix = "", suffix="", limit = 0):
    data = {}
    with open( f"results_08012023/Data/{prefix}_" + country_name + ".txt","r") as f:
        data = json.load(f)
        f.close()
        
    if params == None:
        params = {}
        with open( f"results_08012023/Data/{prefix}_" + country_name + f"_{suffix}_x0_c_L.txt","r") as f:
            params = GetXLC(f.read())
            f.close()
        
    DailyRecovered = np.nan_to_num(np.array(data["DailyRecovered"]).astype(float))
    DailyCases = np.nan_to_num(np.array(data["DailyCases"]).astype(float))
    death_rate = data["DeathRate"]

    print(max(DailyRecovered))
    DailyRecoveredSmooth = pd.DataFrame(DailyRecovered).rolling(swl).sum()/swl
    DailyRecoveredSmooth = np.nan_to_num(DailyRecoveredSmooth .to_numpy().flatten())
    print(max(DailyRecoveredSmooth))
    DailyCasesSmooth = pd.DataFrame(DailyCases).rolling(swl).sum()/swl
    DailyCasesSmooth = np.nan_to_num(DailyCasesSmooth.to_numpy().flatten())

    distributionResult = td.createDistributionArray(DailyCasesSmooth, death_rate, X0=params['x0'], L=params['L'], C=params['C'])
    distArr_trimmed = np.array( distributionResult[:len(DailyRecoveredSmooth)] )
    MSE = math.sqrt( np.square(distArr_trimmed - DailyRecoveredSmooth).mean())
    fitness = 1 / ( 1 + MSE)
    h_t_dist = td.createDistributionArray(DailyCases, death_rate=0, X0=params['x0'], L=params['L'], C=params['C'])
    h_t_dist_trimmed = np.array( h_t_dist[:len(DailyRecoveredSmooth)-1] )

    original_stdout = sys.stdout
    with open("results_08012023/distributions/" + country_name + f"_Distribution_{suffix}_len={len(DailyRecovered)}.txt", "w") as fout:
        sys.stdout = fout
        print(f"best fit genotype: X0: {params['x0']}, C: {params['C']}, L: {params['L']}")
        print(f"MSE for this genotype: {MSE}")
        print(f"fitness : {fitness}")
        sys.stdout = original_stdout

    data_to_save = []
    for i in range(len(h_t_dist_trimmed)):
        data_to_save.append([i, DailyCases[i], h_t_dist_trimmed[i]])
    np.savetxt(f"results_08012023/distributions/{prefix}_{country_name}_{suffix}_Ditributed_t,Ti,Ht.txt", data_to_save, header="Day, Novel Daily Cases, Daily Recoveries + daily deaths : derived by triangular distribution")
    
    if limit != 0:
        DailyCasesG = DailyCasesSmooth[:limit]
        DailyRecoveredG = DailyRecoveredSmooth[:limit]
        distArr_trimmedG = distArr_trimmed[:limit]
    else:
        DailyCasesG = DailyCasesSmooth
        DailyRecoveredG = DailyRecoveredSmooth
        distArr_trimmedG = distArr_trimmed
    plt.plot(DailyCasesG, 'r')
    plt.plot(DailyRecoveredG, 'g')
    plt.plot(distArr_trimmedG, 'k')
    
    
    plt.legend([ "Recorded Daily Cases", "Recorded Daily Recoveries", "Triangular Distribution"])
    plt.xlabel("Day")
    plt.ylabel("Number of Cases")
    plt.savefig("results_08012023/graph_" + country_name + f"_{suffix}_len={len(DailyRecoveredG)}", dpi=1080, bbox_inches="tight")
    plt.close()
    
    return

# runByCountryName("Brazil", {'x0' : 0, 'C' : 15, 'L' : 30}, prefix="27012023", suffix="refTriangle") # shor period optimized
# runByCountryName("Global", {'x0' : 0, 'C' : 15, 'L' : 30}, prefix="27012023", suffix="refTriangle")
# runByCountryName("Germany", {'x0' : 0, 'C' : 15, 'L' : 30}, prefix="27012023", suffix="refTriangle")
# runByCountryName("Italy", {'x0' : 0, 'C' : 15, 'L' : 30}, prefix="27012023", suffix="refTriangle")
# runByCountryName("Japan", {'x0' : 0, 'C' : 15, 'L' : 30}, prefix="27012023", suffix="refTriangle")
# # runByCountryName("Poland", {'x0' : 3, 'C' : 4, 'L' : 30}, prefix="27012023", suffix="refTriangle")
# # runByCountryName("Turkey", {'x0' : 2, 'C' : 5, 'L' : 11}, prefix="27012023", suffix="refTriangle")
# runByCountryName("SouthKorea", {'x0' : 0, 'C' : 15, 'L' : 30}, prefix="27012023", suffix="refTriangle")


# runByCountryName("Brazil", params=None, prefix="27012023", suffix="longOptimized") # long period optimized
# runByCountryName("Global", params=None, prefix="27012023", suffix="longOptimized")
# runByCountryName("Germany", params=None, prefix="27012023", suffix="longOptimized")
# runByCountryName("Italy", params=None, prefix="27012023", suffix="longOptimized")
# runByCountryName("Japan", params=None, prefix="27012023", suffix="longOptimized")
# runByCountryName("SouthKorea", params=None,prefix="27012023", suffix="longOptimized")

runByCountryName("Brazil", params=None, prefix="27012023", suffix="shortOptimized", limit=423)
runByCountryName("Global", params=None, prefix="27012023", suffix="shortOptimized", limit=423)
runByCountryName("Germany", params=None, prefix="27012023", suffix="shortOptimized", limit=423)
runByCountryName("Italy", params=None, prefix="27012023", suffix="shortOptimized", limit=423)
runByCountryName("Japan", params=None, prefix="27012023", suffix="shortOptimized", limit=423)
runByCountryName("SouthKorea", params=None,prefix="27012023", suffix="shortOptimized", limit=423)
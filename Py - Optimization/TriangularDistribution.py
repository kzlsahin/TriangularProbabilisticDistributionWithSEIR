#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 16 00:05:09 2021

@author: kzlsahin
"""
import numpy as np
import pandas as pd
import math
from random import randint
from random import random

def createDistributionArray(inputArray, death_rate, X0=10, C=4, L=35, verbose=False ):
    if L < C:
        print(f'createDistributionArray(inputArray, X0, L=4, C=2))  L should be greater then C. Your inputs: L={L} C={C}')
        return
    
    S = 1
    distributionArray = [0] * (X0 + len(inputArray) + L)
    
    for i in range( len( inputArray ) ):
        
        val_to_distribute = inputArray[i] * ( 1 - death_rate )
        distArr = getNextTriangleDist( val_to_distribute, X0, L, C, S)
        
        for k in range( len( distArr ) ):
            distributionArray[i + X0 + k] += distArr[k]
    
    return distributionArray
    
def getNextTriangleDist(colValue, X0, L, C, S,  verbose=False):
    
    h = 2 * colValue / L
    if verbose==True: print(h)
    distribution = [0] * (L+1)
    distribution[0] = 0
    distribution[L] = 0
    sum = 0
    
    for i in range(1, L):        
        area_i = getAreaInTriangularDist(i, h, L, C)
        area_prev = getAreaInTriangularDist( (i-1), h, L, C)        
        distribution[i] = (area_i - area_prev)
        sum += distribution[i]
        
    if verbose==True: print(f'colValue: {colValue}, sum: {sum}' )
    return distribution

def getAreaInTriangularDist( i, h, L, C, S=1):
    
    Xi = i * S
    
    if Xi < C:
        area = (Xi**2 / 2 ) * (h / C)
    else:
        area = (h * C / 2) + ( h * (2 - (Xi - C) / (L - C) ) * (Xi - C) / 2 )
       
    return area
    
# gens = [ X0, C, L]
boundaries = {'x0':(5,15), 'c':(1, 10), 'L': (11, 41)}
def optimizeByGenetic(arrayToBeDist, targetArray, gens_boundaries, death_rate, mutationRate = 0.05, max_generation = 10, N_survive=15):
        
    targetArray = np.array(targetArray)    
    N = N_survive ** 2
    pop = pd.DataFrame(np.ndarray( (N, 4) ) )
    pop_survived = []
    generation = 0
    history_fitness = {}
    history_pop = {}
    
    
    for i in range(N):
        pop.loc[i] = [ randint(*gens_boundaries['x0']),\
                       randint(*gens_boundaries['c']),\
                       randint(*gens_boundaries['L']), None ]

    
    while generation < max_generation:
        print("generation : {}".format(generation))
        for i in range(N):
            #get distribution array
            distArr = createDistributionArray(arrayToBeDist, death_rate, \
                                              X0 = pop.iloc[i][0].round().astype(int), \
                                              C = pop.iloc[i][1].round().astype(int), \
                                              L = pop.iloc[i][2].round().astype(int))
            
            distArr_trimmed = distArr[ :len(targetArray)] 
            distArr_trimmed = np.array( distArr_trimmed )
            #Mean Squarred Error
            MSE = math.sqrt(np.square(distArr_trimmed - targetArray).mean())
            
            #fitness
            pop.iloc[i][3] = 1 / ( 1 + MSE )
        
        #elitist selection of parents
        pop = pop.sort_values([3])
        history_fitness[generation] = pop.iloc[-1][3]
        pop_survived = pop.iloc[-N_survive:]
        history_pop[generation] = pop_survived.copy()
        best = pop_survived.iloc[-1]
        
        print("pop survived")
        print(pop)
        
        #next generation        
        generation += 1
        #keep best fitted survived for next generation
        index = 0
        
        #crossover
        for parent1 in range(N_survive):
            for parent2 in range(N_survive):
                if parent1 == parent2:
                    #print("equal and passed")
                    continue
                else:
                    #print("index of new ind: {i}".format(i = index))
                    x0 = pop_survived.iloc[parent1][0] if randint(0,1) else pop_survived.iloc[parent2][0]
                    c = pop_survived.iloc[parent1][1] if randint(0,1) else pop_survived.iloc[parent2][1]
                    L = pop_survived.iloc[parent1][2] if randint(0,1) else pop_survived.iloc[parent2][2]
                    pop.iloc[index] = [x0, c, L, None]
                    index += 1
                    
        #mutations
        for i in range(N - N_survive):
            for j, gen in enumerate(gens_boundaries):
                pop.iloc[i][j] = randint(*gens_boundaries[gen]) if random() < mutationRate else pop.iloc[i][j]
        
        
    result = {'Gen Boundaries':gens_boundaries, 'bestGenotype':best, 'hist':{'fitness':history_fitness, 'pops_survived':history_pop} }
    return result

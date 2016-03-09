//
//  PrimeDataSource.swift
//  TableViewPrimes
//
//  Created by weimar on 2/17/16.
//  Copyright © 2016 Weimar. All rights reserved.
//

import Foundation

/*
PrimeDataSource is a helper class to determin all prime nubers up to a certain maximum.
The position of the prime numbers can be determined, and the prime decomposition calculated.

*/
class PrimeDataSource {
    
    var sieve : [Bool]
    var primes : [Int] = []
    let MAX = 1000000
    
    init(var max: Int){
        if (max > MAX+1){
            max = MAX+1
        }
        print("Init to \(max)")
        sieve = [Bool](count: max, repeatedValue: true)
        
        sieve[0] = false
        sieve[1] = false
        
        var i=2
        for ( ; i < max && i*i <= max; i++ ) {
            if (sieve[i]){
                primes.append(i)
                for (var j=2; i*j<max; j++ ) {
                    sieve[i*j] = false;
                }
            }
        }
        for ( ; i < max ; i++ ) {
            if (sieve[i]){
                primes.append(i)
            }
        }

    }
    
    var size: Int {
        return sieve.endIndex+1
    }
    
    func getName (num: Int) -> String {
        return String(num)
    }
    
    func isPrime(num: Int) -> Bool {
        return sieve[num]
    }
    
    func decomposition( var num: Int) -> [(Int, Int)]{
        var result = [(Int, Int)]()
        var i = 0
        while ( num > 1){
            var j = 0
            let base = primes[i]
            while ( num % base == 0) {
                num /= base
                j = j+1
            }
            if (j != 0){
                result.append( (base, j) )
            }
            i = i + 1
        }
        return result
    }
    
    func indexInPrimes(num: Int) -> Int {
        let ind = primes.indexOf(num)
        if let index = ind {
            return index+1
        }else{
            return -1
        }
    }
    
    func prime(atPosition pos: Int) -> Int? {
        if (pos <= primes.endIndex){
            return primes[pos-1]
        }else{
            return nil;
        }
    }
    
    func decompositionAsProduct(num: Int) -> String {
        var res=""
            let decomp = decomposition(num)
            var first = true
            for (base, exp) in decomp {
                for _ in 1...exp {
                    if (first){
                        first = false
                    }else{
                        res.appendContentsOf("*")
                    }
                    res.appendContentsOf(String(base))
                }
            }
        return res
    }
    
}

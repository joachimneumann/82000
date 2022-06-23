//
//  main.swift
//  82000
//
//  Created by Joachim Neumann on 6/21/22.
//

import Foundation

let base5N = 20
var base5 = Array(repeating: 0, count: base5N)
var base5Values = Array(repeating: 0, count: base5N)
var n: BInt = 0

func increaseAt(_ index: Int) -> Int {
    /// if 0 -> 1
    /// else set to zero and increase next
    if base5[index] == 0 {
        base5[index] += 1
        return base5Values[index]
    } else {
        let decrease = base5Values[index] * base5[index]
        base5[index] = 0
        let increase = increaseAt(index+1) - decrease
        return increase
    }
}

base5Values[0] = 1
for i in 1...base5N-1 {
    base5Values[i] = 5 * base5Values[i-1]
}

for _ in 0...2000 {
    n += increaseAt(0)
    print(printBase5() + " " + String(n))
}


func printBase5() -> String {
    var ret = ""
    for index in (0...base5N-1).reversed() {
        ret += String(base5[index])
    }
    return ret
}


//
//  main.swift
//  82000
//
//  Created by Joachim Neumann on 6/21/22.
//

import Foundation

let base5N = 40
var base5 = Array(repeating: 0, count: base5N)
var base5Values = Array(repeating: BInt(0), count: base5N)
var n: BInt = 0

func increaseAt(_ index: Int) -> BInt {
    /// if 0 -> 1, otherwise: set to zero and increase next
    if base5[index] == 0 {
        base5[index] += 1
        return base5Values[index]
    } else {
        let decrease = base5Values[index] * base5[index]
        base5[index] = 0
        let increase:BInt = increaseAt(index+1) - decrease
        return increase
    }
}

/// precalculate 5^^x
base5Values[0] = 1
for i in 1...base5N-1 {
    base5Values[i] = BInt(5) * base5Values[i-1]
}

/// Trick to check if a number is represented in the base 4 system by only 0 or 1:
/// 1. binary AND the number with 0b...101010101010101010
/// 2. If the result is 0, then the number is represented in the base 4 system by only 0 and 1

var base4Check:BInt = 0
var f:BInt = 2
while base4Check < base5Values[base5N-1] * 10 {
    base4Check += f
    f *= BInt(4)
}

var zeroAndOne: Set<Character> = ["0", "1"]

let printInterval:BInt = 1000000000
var printValue:BInt = printInterval

while true {
    n += increaseAt(0)
    if (base4Check & n) == 0 {
        let base3 = n.asString(radix: 3).replacingOccurrences(of: "0", with: "").replacingOccurrences(of: "1", with: "")
        if base3.count == 0 {
            print(String(n) + " " + n.asString(radix: 5) + " " + n.asString(radix: 4) + " " + n.asString(radix: 3))
        }
    }
    if n > printValue {
        let s = String(n)
        var r = String(s.reversed())
        r.insert(separator: ".", every: 3)
        r = r.padding(toLength: base5N, withPad: " ", startingAt: 0)
        r = String(r.reversed())
        print(r)
        while printValue < n {
            printValue += printInterval
        }
        if n > base4Check {
            print("n > base4Check "+String(n)+" "+String(base4Check))
        }
        if n > base5Values[base5N-1] {
            print("n > base5[base5N-1] "+String(n)+" "+String(base5[base5N-1]))
        }
    }
}


extension Collection {

    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < endIndex else { return nil }
            let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }

    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { let _ = formIndex(&index, offsetBy: n, limitedBy: endIndex) }
            return self[index]
        }
    }

    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension StringProtocol where Self: RangeReplaceableCollection {

    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }

    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}

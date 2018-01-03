//
//  Random.swift
//  storageComapre
//
//  Created by Michal Kolbusz on 1/3/18.
//  Copyright © 2018 Użytkownik Gość. All rights reserved.
//

import Foundation
//struct Random {
//    static func within<B: Comparable & Comparable>(range: ClosedRange<B>) -> B {
//        let inclusiveDistance = range.lowerBound.distanceTo(range.upperBound).successor()
//        let randomAdvance = B.Distance(arc4random_uniform(UInt32(inclusiveDistance.toIntMax())).toIntMax())
//        return range.start.advancedBy(randomAdvance)
//    }
//    
//    static func within(range: ClosedRange<Float>) -> Float {
//        return (range.upperBound - range.lowerBound) * Float(Float(arc4random()) / Float(UInt32.max)) + range.lowerBound
//    }
//    
//    static func within(range: ClosedRange<Double>) -> Double {
//        return (range.upperBound - range.lowerBound) * Double(Double(arc4random()) / Double(UInt32.max)) + range.lowerBound
//    }
//    
//    static func generate() -> Int {
//        return Random.within(0...1)
//    }
//    
//    static func generate() -> Bool {
//        return Random.generate() == 0
//    }
//    
//    static func generate() -> Float {
//        return Random.within(0.0...1.0)
//    }
//    
//    static func generate() -> Double {
//        return Random.within(0.0...1.0)
//    }
//}

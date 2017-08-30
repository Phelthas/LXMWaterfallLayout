//
//  TestArrayExtension.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/29.
//  Copyright © 2017年 duowan. All rights reserved.
//

import Foundation
import UIKit


extension Array {
    public mutating func append(_ newElement: Element?) {
        if let newElement = newElement {
            self.append(newElement)
        }
    }
    
    public mutating func append<S>(contentsOf newElements: S?) where S : Sequence, S.Iterator.Element == Element {
        if let newElements = newElements {
            self.append(contentsOf: newElements)
        }
    }
    
    public mutating func insert(_ newElement: Element?, at i: Int) {
        if let newElement = newElement {
            self.insert(newElement, at: i)
        }
    }
}

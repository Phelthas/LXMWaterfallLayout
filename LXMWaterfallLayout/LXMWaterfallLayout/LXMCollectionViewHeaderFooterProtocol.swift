//
//  LXMCollectionViewHeaderFooterProtocol.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/26.
//  Copyright © 2017年 duowan. All rights reserved.
//

import Foundation
import UIKit


private let kLXMCollectionViewHeaderHeightKey = "kLXMCollectionViewHeaderHeightKey"
private let kLXMCollectionViewFooterHeightKey = "kLXMCollectionViewFooterHeightKey"

protocol LXMCollectionViewHeaderFooterProtocol {
    var collectionViewHeaderHeight: CGFloat { get set }
    
    var collectionViewFooterHeight: CGFloat { get set }
    
    
    var collectionViewHeaderAttributes: UICollectionViewLayoutAttributes? { get set }
    
    var collectionViewFooterAttributes: UICollectionViewLayoutAttributes? { get set }
}

extension LXMCollectionViewHeaderFooterProtocol where Self: UICollectionViewLayout {
    
    
    

    
    var collectionViewHeaderHeight: CGFloat {
        set {
            objc_setAssociatedObject(self, kLXMCollectionViewHeaderHeightKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, kLXMCollectionViewHeaderHeightKey) as? CGFloat ?? 0
        }
        
    }
    
//    var collectionViewFooterHeight: CGFloat {
//        set {
//            objc_setAssociatedObject(<#T##object: Any!##Any!#>, <#T##key: UnsafeRawPointer!##UnsafeRawPointer!#>, <#T##value: Any!##Any!#>, <#T##policy: objc_AssociationPolicy##objc_AssociationPolicy#>)
//        }
//        get {
//            
//        }
//    }
//    
//    
//    var collectionViewHeaderAttributes: UICollectionViewLayoutAttributes?
//    
//    var collectionViewFooterAttributes: UICollectionViewLayoutAttributes?
}


extension UICollectionViewLayout {
    private struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
        
        let aaa = UnsafeRawPointer()
        let bbb = String()
    }
}

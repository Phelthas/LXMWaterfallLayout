//
//  LXMLayoutHeaderFooterProtocol.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/26.
//  Copyright © 2017年 duowan. All rights reserved.
//

import Foundation
import UIKit


public let LXMCollectionElementKindHeader: String = "LXMCollectionElementKindHeader"

public let LXMCollectionElementKindFooter: String = "LXMCollectionElementKindFooter"


/// 此协议声明成只有类可以遵守，因为本来就是给UICollectionViewLayout用的
/// 因为里面有修改self属性的方法，如果结构体等值类型也可以遵守该协议的话，会复杂很多
/// 具体原因见：https://www.bignerdranch.com/blog/protocol-oriented-problems-and-the-immutable-self-error/
protocol LXMLayoutHeaderFooterProtocol: class {
    
    var collectionViewHeaderHeight: CGFloat { get set }
    
    var collectionViewFooterHeight: CGFloat { get set }
    
    
    /// 如果collectionViewHeaderHeight > 0 则有默认值，否则为nil
    /// 可以通过赋值nil来重新生成默认值
    var collectionViewHeaderAttributes: UICollectionViewLayoutAttributes? { get set }
    
    /// 如果collectionViewFooterHeight > 0 则有默认值，否则为nil
    /// 可以通过赋值nil来重新生成默认值
    var collectionViewFooterAttributes: UICollectionViewLayoutAttributes? { get set }
    
    
    /// 遍历所有section用
    /// ```
    /// self.layoutAttributesForItem(at: indexPath)
    /// self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
    /// self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: indexPath)
    /// ```
    /// 这三个方法获取所有的attributes属性，如果collectionViewHeaderAttributes或collectionViewFooterAttributes存在的话，再加上这两个，作为allAttributesArray的默认值
    /// 所以如果要遵从本协议的话，以上三个方法必须要实现
    /// 可以通过赋值nil来重新生成默认值
    var allAttributesArray: [UICollectionViewLayoutAttributes]? { get set }
    
    func updateAttributesForHeaderAndFooter(attributes: UICollectionViewLayoutAttributes?) -> UICollectionViewLayoutAttributes?
    
    func updateContentSizeForHeaderAndFooter(contentSize: CGSize) -> CGSize
    
 
}



private var kLXMCollectionViewHeaderHeightKey: String = "kLXMCollectionViewHeaderHeightKey"
private var kLXMCollectionViewFooterHeightKey: String = "kLXMCollectionViewFooterHeightKey"
private var kLXMCollectionViewHeaderAttributesKey: String = "kLXMCollectionViewHeaderAttributesKey"
private var kLXMCollectionViewFooterAttributesKey: String = "kLXMCollectionViewFooterAttributesKey"
private var kLXMCollectionViewAllAttributesArrayKey: String = "kLXMCollectionViewAllAttributesArrayKey"

extension LXMLayoutHeaderFooterProtocol where Self: UICollectionViewLayout {
    
    var collectionViewHeaderHeight: CGFloat {
        set {
            assert(newValue >= 0, "collectionViewHeaderHeight must be equal or greater than 0 !!!")
            let value = NSNumber(value: Float(newValue))
            objc_setAssociatedObject(self, &kLXMCollectionViewHeaderHeightKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let value = objc_getAssociatedObject(self, &kLXMCollectionViewHeaderHeightKey) as? NSNumber {
                return CGFloat(value.floatValue)
            }
            return 0
        }
    }
    
    var collectionViewFooterHeight: CGFloat {
        set {
            assert(newValue >= 0, "collectionViewFooterHeight must be equal or greater than 0 !!!")
            let value = NSNumber(value: Float(newValue))
            objc_setAssociatedObject(self, &kLXMCollectionViewFooterHeightKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let value = objc_getAssociatedObject(self, &kLXMCollectionViewFooterHeightKey) as? NSNumber {
                return CGFloat(value.floatValue)
            }
            return 0
        }
    }
    
    var collectionViewHeaderAttributes: UICollectionViewLayoutAttributes? {
        set {
            objc_setAssociatedObject(self, &kLXMCollectionViewHeaderAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let attributes = objc_getAssociatedObject(self, &kLXMCollectionViewHeaderAttributesKey) as? UICollectionViewLayoutAttributes {
                return attributes
            } else {
                if let collectionView = self.collectionView, self.collectionViewHeaderHeight > 0 {
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindHeader, with: IndexPath())
                    attributes.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: self.collectionViewHeaderHeight)
                    self.collectionViewHeaderAttributes = attributes
                    return attributes
                }
                return nil
            }
        }
    }
    
    var collectionViewFooterAttributes: UICollectionViewLayoutAttributes? {
        set {
            objc_setAssociatedObject(self, &kLXMCollectionViewFooterAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let attributes = objc_getAssociatedObject(self, &kLXMCollectionViewFooterAttributesKey) as? UICollectionViewLayoutAttributes {
                return attributes
            } else {
                if let collectionView = self.collectionView, self.collectionViewFooterHeight > 0 {
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindFooter, with: IndexPath())
                    attributes.frame = CGRect(x: 0, y: self.collectionViewContentSize.height - self.collectionViewFooterHeight, width: collectionView.bounds.width, height: self.collectionViewFooterHeight)
                    self.collectionViewFooterAttributes = attributes
                    return attributes
                }
                return nil
            }
        }
    }
    
    var allAttributesArray: [UICollectionViewLayoutAttributes]? {
        set {
            objc_setAssociatedObject(self, &kLXMCollectionViewAllAttributesArrayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let attributesArray = objc_getAssociatedObject(self, &kLXMCollectionViewAllAttributesArrayKey) as? [UICollectionViewLayoutAttributes] {
                return attributesArray
            } else {
                if let collectionView = self.collectionView {
                    let numberOfSections = collectionView.numberOfSections
                    if numberOfSections <= 0 {
                        return nil
                    }
                    var attributesArray = [UICollectionViewLayoutAttributes]()
                    for section in 0 ..< numberOfSections {
                        for index in 0 ..< collectionView.numberOfItems(inSection: section) {
                            let indexPath = IndexPath(item: index, section: section)
                            let itemAttributes = self.layoutAttributesForItem(at: indexPath)
                            attributesArray.append(itemAttributes)
                            
                            let sectionHeaderAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
                            attributesArray.append(sectionHeaderAttributes)
                            
                            let sectionFooterAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: indexPath)
                            attributesArray.append(sectionFooterAttributes)
                        }
                    }
                    attributesArray.append(self.collectionViewHeaderAttributes)
                    attributesArray.append(self.collectionViewFooterAttributes)
                    self.allAttributesArray = attributesArray
                    return attributesArray
                }
                return nil
            }
        }
    }
    
    
    
    
    func updateAttributesForHeaderAndFooter(attributes: UICollectionViewLayoutAttributes?) -> UICollectionViewLayoutAttributes? {
        if let result = attributes?.copy() as? UICollectionViewLayoutAttributes {
            result.frame.origin.y += self.collectionViewHeaderHeight
            return result
        }
        return nil
        
    }
    
    func updateContentSizeForHeaderAndFooter(contentSize: CGSize) -> CGSize {
        var size = contentSize
        size.height += self.collectionViewHeaderHeight + self.collectionViewFooterHeight
        return size
    }
    
    
}






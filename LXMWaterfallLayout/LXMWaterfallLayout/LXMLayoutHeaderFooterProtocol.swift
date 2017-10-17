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
/// 里面有修改self属性的方法，如果结构体等值类型也可以遵守该协议的话，会复杂很多
/// 具体原因见：https://www.bignerdranch.com/blog/protocol-oriented-problems-and-the-immutable-self-error/
public protocol LXMLayoutHeaderFooterProtocol: class {
    
    var collectionViewHeaderHeight: CGFloat { get set }
    
    var collectionViewFooterHeight: CGFloat { get set }
    
    /// 如果collectionViewHeaderHeight > 0 则有默认值，否则为nil
    /// 可以通过赋值nil来重新生成默认值
    var collectionViewHeaderAttributes: UICollectionViewLayoutAttributes? { get set }
    
    /// 如果collectionViewFooterHeight > 0 则有默认值，否则为nil
    /// 可以通过赋值nil来重新生成默认值
    var collectionViewFooterAttributes: UICollectionViewLayoutAttributes? { get set }
    
}



private var kLXMCollectionViewHeaderHeightKey: String = "kLXMCollectionViewHeaderHeightKey"
private var kLXMCollectionViewFooterHeightKey: String = "kLXMCollectionViewFooterHeightKey"
private var kLXMCollectionViewHeaderAttributesKey: String = "kLXMCollectionViewHeaderAttributesKey"
private var kLXMCollectionViewFooterAttributesKey: String = "kLXMCollectionViewFooterAttributesKey"

public extension LXMLayoutHeaderFooterProtocol where Self: UICollectionViewLayout {
    
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
                if self.collectionViewHeaderHeight > 0 {
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindHeader, with: IndexPath())
                    attributes.frame = CGRect(x: 0,
                                              y: 0,
                                              width: self.collectionViewContentSize.width,
                                              height: self.collectionViewHeaderHeight)
                    if let layout = self as? UICollectionViewFlowLayout, layout.scrollDirection == .horizontal {
                        attributes.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: self.collectionViewHeaderHeight,
                                                  height: self.collectionViewContentSize.height)
                    }
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
                if self.collectionViewFooterHeight > 0 {
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindFooter, with: IndexPath())
                    attributes.frame = CGRect(x: 0,
                                              y: self.collectionViewContentSize.height - self.collectionViewFooterHeight,
                                              width: self.collectionViewContentSize.width,
                                              height: self.collectionViewFooterHeight)
                    if let layout = self as? UICollectionViewFlowLayout, layout.scrollDirection == .horizontal {
                        attributes.frame = CGRect(x: self.collectionViewContentSize.width - self.collectionViewFooterHeight,
                                                  y: 0,
                                                  width: self.collectionViewFooterHeight,
                                                  height: self.collectionViewContentSize.height)
                    }
                    self.collectionViewFooterAttributes = attributes
                    return attributes
                }
                return nil
            }
        }
    }
    

    
    func updateAttributesForHeaderAndFooter(attributes: UICollectionViewLayoutAttributes?) -> UICollectionViewLayoutAttributes? {
        if let result = attributes?.copy() as? UICollectionViewLayoutAttributes {
            
            if let layout = self as? UICollectionViewFlowLayout, layout.scrollDirection == .horizontal {
                result.frame.origin.x += self.collectionViewHeaderHeight
            } else {
                result.frame.origin.y += self.collectionViewHeaderHeight
            }

            return result
        }
        return nil
        
    }
    
    func updateContentSizeForHeaderAndFooter(contentSize: CGSize) -> CGSize {
        var size = contentSize
        if let layout = self as? UICollectionViewFlowLayout, layout.scrollDirection == .horizontal {
            size.width += self.collectionViewHeaderHeight + self.collectionViewFooterHeight
        } else {
            size.height += self.collectionViewHeaderHeight + self.collectionViewFooterHeight
        }
        return size
    }
    
    
    
    
}



private var kLXMCollectionViewSectionItemAttributesDictKey = "kLXMCollectionViewSectionItemAttributesDictKey"
private var kLXMCollectionViewSectionHeaderAttributesDictKey = "kLXMCollectionViewSectionHeaderAttributesDictKey"
private var kLXMCollectionViewSectionFooterAttributesDictKey = "kLXMCollectionViewSectionFooterAttributesDictKey"
private var kLXMCollectionViewAllAttributesArrayKey = "kLXMCollectionViewAllAttributesArrayKey"

public extension UICollectionViewLayout {
    
    /// 保存每个section中每个item的Attributes的字典，key是section
    var sectionItemAttributesDict: [Int : [UICollectionViewLayoutAttributes]]? {
        set {
            objc_setAssociatedObject(self, &kLXMCollectionViewSectionItemAttributesDictKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kLXMCollectionViewSectionItemAttributesDictKey) as? [Int : [UICollectionViewLayoutAttributes]]
        }
    }
    
    
    // 保存sectionHeader的attributes的字典，key是section
    var sectionHeaderAttributesDict: [Int : UICollectionViewLayoutAttributes]? {
        set {
            objc_setAssociatedObject(self, &kLXMCollectionViewSectionHeaderAttributesDictKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kLXMCollectionViewSectionHeaderAttributesDictKey) as? [Int : UICollectionViewLayoutAttributes]
        }
    }
    
    /// 保存sectionFooter的attributes的字典，key是section
    var sectionFooterAttributesDict: [Int : UICollectionViewLayoutAttributes]? {
        set {
            objc_setAssociatedObject(self, &kLXMCollectionViewSectionFooterAttributesDictKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kLXMCollectionViewSectionFooterAttributesDictKey) as? [Int : UICollectionViewLayoutAttributes]
        }
    }
    
    /// 所有item的attributes的数组，包括cell和SectionHeader，SectionFooter, collectionViewHeader, collectionViewFooter
    var allAttributesArray: [UICollectionViewLayoutAttributes]? {
        set {
            objc_setAssociatedObject(self, &kLXMCollectionViewAllAttributesArrayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kLXMCollectionViewAllAttributesArrayKey) as? [UICollectionViewLayoutAttributes]
        }
    }
    
    func clearAttributesIfEmpty() {
        if let dict = self.sectionItemAttributesDict, dict.isEmpty {
            self.sectionItemAttributesDict = nil
        }
        if let dict = self.sectionHeaderAttributesDict, dict.isEmpty {
            self.sectionHeaderAttributesDict = nil
        }
        if let dict = self.sectionFooterAttributesDict, dict.isEmpty {
            self.sectionFooterAttributesDict = nil
        }
        if let dict = self.allAttributesArray, dict.isEmpty {
            self.allAttributesArray = nil
        }
    }
    
}



// MARK: - Tool
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


// MARK: - Tool
public extension UICollectionViewFlowLayout {
    
    fileprivate var delegate: UICollectionViewDelegateFlowLayout? {
        return self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }
    
    func sizeForItem(atIndexPath indexPath: IndexPath) -> CGSize {
        if let collectionView = self.collectionView {
            return self.delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
        }
        return self.itemSize
    }
    
    func insetForSection(at section: Int) -> UIEdgeInsets {
        if let collectionView = self.collectionView {
            return self.delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? self.sectionInset
        }
        return self.sectionInset
    }
    
    func minimumLineSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView {
            return self.delegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? self.minimumLineSpacing
        }
        return self.minimumLineSpacing
    }
    
    func minimumInteritemSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView {
            return self.delegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? self.minimumInteritemSpacing
        }
        return self.minimumInteritemSpacing
    }
    
    func referenceSizeForHeaderInSection(section: Int) -> CGSize {
        if let collectionView = self.collectionView {
            return self.delegate?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? self.headerReferenceSize
        }
        return self.headerReferenceSize
    }
    
    func referenceSizeForFooterInSection(section: Int) -> CGSize {
        if let collectionView = self.collectionView {
            return self.delegate?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? self.footerReferenceSize
        }
        return self.footerReferenceSize
    }
    
}


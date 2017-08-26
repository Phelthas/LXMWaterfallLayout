//
//  LXMHeaderFooterFlowLayout.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/26.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit


public let LXMCollectionElementKindTotalHeader: String = "LXMCollectionElementKindTotalHeader"

public let LXMCollectionElementKindTotalFooter: String = "LXMCollectionElementKindTotalFooter"


class LXMHeaderFooterFlowLayout: UICollectionViewFlowLayout {

    open var collectionViewHeaderHeight: CGFloat = 0
    
    open var collectionViewFooterHeight: CGFloat = 0
    
    
    fileprivate var collectionViewHeaderAttributes: UICollectionViewLayoutAttributes?
    
    fileprivate var collectionViewFooterAttributes: UICollectionViewLayoutAttributes?
    
    
}



// MARK: - override
extension LXMHeaderFooterFlowLayout {
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        let collectionViewWidth = collectionView.bounds.width
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections <= 0 {
            return
        }
        
        self.collectionViewHeaderAttributes = nil
        self.collectionViewFooterAttributes = nil
        
        //collectionViewHeader
        assert(self.collectionViewHeaderHeight >= 0, "collectionViewHeaderHeight must be equal or greater than 0 !!!")
        if self.collectionViewHeaderHeight > 0 {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindCollectionViewHeader, with: IndexPath())
            attributes.frame = CGRect(x: 0, y: 0, width: collectionViewWidth, height: self.collectionViewHeaderHeight)
            self.collectionViewHeaderAttributes = attributes
            
        }
        
        //collectionViewFooter
        assert(self.collectionViewFooterHeight >= 0, "collectionViewFooterHeight must be equal or greater than 0 !!!")
        if self.collectionViewFooterHeight > 0 {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindCollectionViewFooter, with: IndexPath())
            attributes.frame = CGRect(x: 0, y: collectionViewContentSize.height - collectionViewFooterHeight, width: collectionViewWidth, height: self.collectionViewFooterHeight)
            self.collectionViewFooterAttributes = attributes
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultArray = [UICollectionViewLayoutAttributes]()
        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y - self.collectionViewHeaderHeight, width: rect.width, height: rect.height + self.collectionViewHeaderHeight + self.collectionViewFooterHeight)
        
        if let array = super.layoutAttributesForElements(in: newRect) {
            for attributes in array {
                let copedAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
                copedAttributes.frame.origin.y += self.collectionViewHeaderHeight
                resultArray.append(copedAttributes)
            }
        }
        if let headerAttributes = self.collectionViewHeaderAttributes {
            if headerAttributes.frame.intersects(rect) {
                resultArray.append(headerAttributes)
            }
        }
        if let footerAttributes = self.collectionViewFooterAttributes {
            if footerAttributes.frame.intersects(rect) {
                resultArray.append(footerAttributes)
            }
        }
        return resultArray.isEmpty ? nil : resultArray
    }
    
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        attributes?.frame.origin.y += self.collectionViewHeaderHeight
        return attributes
    }
    
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == LXMCollectionElementKindTotalHeader {
            return self.collectionViewHeaderAttributes
        } else if elementKind == LXMCollectionElementKindTotalFooter {
            return self.collectionViewFooterAttributes
        } else {
            let attributes = layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
            attributes?.frame.origin.y += self.collectionViewHeaderHeight
            return attributes
        }
        
    }
    
    
    open override var collectionViewContentSize: CGSize {
        var size = super.collectionViewContentSize
        size.height += self.collectionViewHeaderHeight + self.collectionViewFooterHeight
        return size
    }
    
    
    open override func shouldInvalidateLayout (forBoundsChange newBounds: CGRect) -> Bool {
        if let collectionView = self.collectionView {
            if newBounds.width != collectionView.bounds.width {
                return true
            }
        }
        return false
    }
    
    
    
    
    
}

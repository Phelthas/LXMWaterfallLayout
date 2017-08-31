//
//  LXMHeaderFooterFlowLayout.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/29.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit

class LXMHeaderFooterFlowLayout: UICollectionViewFlowLayout, LXMLayoutHeaderFooterProtocol {
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections <= 0 {
            return
        }
        self.collectionViewHeaderAttributes = nil
        self.collectionViewFooterAttributes = nil
        self.allAttributesArray = nil
    }
    
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //注意，这里直接调用super.layoutAttributesForElements(in rect: CGRect)在修改里面UICollectionViewLayoutAttributes的方法是不行的，系统应该是有做缓存，当所有UICollectionViewLayoutAttributes存在以后，系统就不会再调用此方法。这里因为多了header，所有item的位置都会相应下移，可能会使缓存的与返回的item有重复，导致位置错误
        return self.allAttributesArray?.filter({ (attributes) -> Bool in
            return attributes.frame.intersects(rect)
        })
        
    }
    
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        return updateAttributesForHeaderAndFooter(attributes: attributes)
    }
    
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == LXMCollectionElementKindHeader {
            return self.collectionViewHeaderAttributes
        } else if elementKind == LXMCollectionElementKindFooter {
            return self.collectionViewFooterAttributes
        } else {
            let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
            return updateAttributesForHeaderAndFooter(attributes: attributes)
        }
        
    }
    
    
    /// 注意：一定要用super.collectionViewContentSize返回的宽度，系统貌似根据contentInset做了优化计算
    open override var collectionViewContentSize: CGSize {
        return updateContentSizeForHeaderAndFooter(contentSize: super.collectionViewContentSize)
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


//
//  MyTestLayout.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/9/6.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit



/// 这个类演示如何创建一个自己的类，并让它遵从LXMLayoutHeaderFooterProtocol
/// 如果只是自己用的，确定不会调用到 `layoutAttributesForItem(at indexPath: IndexPath)`
/// 或者`layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath)`
/// 那这两个方法就可以不用实现，只用实现`layoutAttributesForElements(in rect: CGRect)`即可
class MyTestLayout: UICollectionViewFlowLayout, LXMLayoutHeaderFooterProtocol {

    
}

extension MyTestLayout {
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections <= 0 {
            return
        }
        
        self.collectionViewHeaderAttributes = nil
        self.collectionViewFooterAttributes = nil
        self.allAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for section in 0 ..< numberOfSections {
            for index in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: index, section: section)
                let itemAttributes = super.layoutAttributesForItem(at: indexPath)
                self.allAttributesArray?.append(itemAttributes)
            }
            
            let headerAttributes = super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: section))
            self.allAttributesArray?.append(headerAttributes)
            
            let footerAttributes = super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: IndexPath(item: 0, section: section))
            self.allAttributesArray?.append(footerAttributes)
            
        }
        self.allAttributesArray = self.allAttributesArray?.map({ (attributes) in
            let copyed = attributes.copy() as? UICollectionViewLayoutAttributes
            return self.updateAttributesForHeaderAndFooter(attributes: copyed)!
        })
        
        self.allAttributesArray?.append(self.collectionViewHeaderAttributes)
        self.allAttributesArray?.append(self.collectionViewFooterAttributes)
        
        if let array = self.allAttributesArray, array.isEmpty {
            self.allAttributesArray = nil
        }
        
        
        
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.allAttributesArray?.filter({ (attributes) -> Bool in
            return attributes.frame.intersects(rect)
        })
    }
    
    
    /// 如果确定不会使用到改方法，那这个方法可以不用实现
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        return self.updateAttributesForHeaderAndFooter(attributes: attributes)
    }
    
    /// 如果确定不会使用到改方法，那这个方法可以不用实现
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == LXMCollectionElementKindHeader {
            return self.collectionViewHeaderAttributes
        } else if elementKind == LXMCollectionElementKindFooter {
            return self.collectionViewFooterAttributes
        } else {
            let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
            return self.updateAttributesForHeaderAndFooter(attributes: attributes)
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

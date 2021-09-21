//
//  LXMHorizontalMenuLayout.swift
//  LXMWaterfallLayout
//
//  Created by billthaslu on 2021/9/12.
//  Copyright © 2021 duowan. All rights reserved.
//

import UIKit

@objc public protocol LXMHorizontalMenuLayoutDelegate : UICollectionViewDelegate {
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMHorizontalMenuLayout, sizeForItemAt index: Int) -> CGSize
}

open class LXMHorizontalMenuLayout: UICollectionViewLayout {

    open var interitemSpacing: CGFloat = 10;

    open var itemSize: CGSize = CGSize(width: 50, height: 50)
    
    open var sectionInset: UIEdgeInsets = UIEdgeInsets.zero

    fileprivate weak var delegate: LXMHorizontalMenuLayoutDelegate? {
        return self.collectionView?.delegate as? LXMHorizontalMenuLayoutDelegate
    }
    
    /// 所有item总宽度，不包含间距
    fileprivate var itemTotalWidth: CGFloat = 0
    
    /// item正常排布时的contentWidth，包含间距和SectionInset
    fileprivate var normalContentWidth: CGFloat = 0
    
    /// item正常排布时的contentHeight，包含间距和SectionInset
    fileprivate var normalContentHeight: CGFloat = 0
    
    /// 所有item的Attributes数组
    fileprivate var itemAttributesArray = [UICollectionViewLayoutAttributes]()
    
}

/// MARK: - override
extension LXMHorizontalMenuLayout {
    
    open override func prepare() {
        super.prepare()
        guard let sectionCount = self.collectionView?.numberOfSections,
            sectionCount == 1 else {
            assert(false, "目前仅支持 1 个section")
            return
        }
        guard let itemCount = self.collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        
        self.itemAttributesArray.removeAll()
        self.normalContentWidth = self.sectionInset.left
        self.normalContentHeight = 0
        self.itemTotalWidth = 0
        for index in 0 ..< itemCount {
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            let itemSize = self.delegateItemSizeForCellAtIndex(index: index)
            itemAttributes.frame = CGRect(x: self.normalContentWidth, y: self.sectionInset.top, width: itemSize.width, height: itemSize.height)
            self.itemAttributesArray.append(itemAttributes)
            self.normalContentWidth += itemSize.width;
            self.itemTotalWidth += itemSize.width;
            if index != itemCount - 1 {
                self.normalContentWidth += self.interitemSpacing
            }
            if itemSize.height > self.normalContentHeight {
                self.normalContentHeight = itemSize.height
            }
        }
        self.normalContentWidth += self.sectionInset.right;
        self.normalContentHeight += self.sectionInset.top + self.sectionInset.bottom

        if self.shouldAdjustItemFrame() {
            self.updateAttributesForEvenLayout()
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = self.itemAttributesArray.filter { attributes in
            return rect.intersects(attributes.frame)
        }
        return array
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributesArray[indexPath.item]
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        assert(false, "暂时不支持SupplementaryView")
        return nil
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        assert(false, "暂时不支持DecorationView")
        return nil
    }
    
    open override var collectionViewContentSize: CGSize {
        if self.shouldAdjustItemFrame() {
            return CGSize(width: self.collectionView?.bounds.width ?? 0, height: self.normalContentHeight)
        } else {
            return CGSize(width: self.normalContentWidth, height: self.normalContentHeight)
        }
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let size = self.collectionView?.bounds.size else { return false }
        return size.equalTo(newBounds.size)
    }
    
}

// MARK: - PrivateMethod
private extension LXMHorizontalMenuLayout {
    
    func delegateItemSizeForCellAtIndex(index: Int) -> CGSize {
        if let collectionView = self.collectionView,
           let itemSize = self.delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: index) {
                return itemSize
        }
        return self.itemSize
    }
    
    func shouldAdjustItemFrame() -> Bool {
        if let width = self.collectionView?.bounds.size.width,
           width > self.normalContentWidth {
            return true
        }
        return false
    }
    
    func evenLayoutSpacing() -> CGFloat {
        guard let itemCount = self.collectionView?.numberOfItems(inSection: 0),
              let width = self.collectionView?.bounds.size.width else {
            return 0
        }
        let spacing = floor((width - self.itemTotalWidth) / CGFloat((itemCount + 1)))
        return spacing
    }
    
    func updateAttributesForEvenLayout() {
        guard let sectionCount = self.collectionView?.numberOfSections,
            sectionCount == 1 else {
            assert(false, "目前仅支持 1 个section")
            return
        }
        let itemCount = self.itemAttributesArray.count
        let spacing = self.evenLayoutSpacing()
        var offsetX = spacing
        for i in 0 ..< itemCount {
            let itemAttributes = self.itemAttributesArray[i]
            var frame = itemAttributes.frame
            frame.origin.x = offsetX
            itemAttributes.frame = frame
            offsetX += itemAttributes.frame.size.width + spacing;
        }
    }
    
}


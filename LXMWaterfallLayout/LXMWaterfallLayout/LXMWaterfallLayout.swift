//
//  LXMWaterfallLayout.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/23.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit


public let LXMCollectionElementKindSectionHeader: String = "LXMCollectionElementKindSectionHeader"

public let LXMCollectionElementKindSectionFooter: String = "LXMCollectionElementKindSectionFooter"

public let LXMCollectionElementKindCollectionViewHeader: String = "LXMCollectionElementKindCollectionViewHeader"

public let LXMCollectionElementKindCollectionViewFooter: String = "LXMCollectionElementKindCollectionViewFooter"


@objc public protocol LXMWaterfallLayoutDelegate: UICollectionViewDelegate {
    
    /// 请求delegate每个item的大小，如果没有实现该方法，那itemSize将是计算出来的边长为columnWidth的正方形
    /// 注意：如果返回的宽度小于计算出来的columnWidth,那实际显示的大小是将itemSize按比例缩放到“宽==columnWidth”的大小
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMWaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMWaterfallLayout, numberOfColumnsAt section: Int) -> Int
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMWaterfallLayout, minimumColumnSpacingForSectionAt section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMWaterfallLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMWaterfallLayout, heightForSectionHeaderInSection section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMWaterfallLayout, heightForSectionFooterInSection section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMWaterfallLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
}

open class LXMWaterfallLayout: UICollectionViewLayout {
    
    open var columnCount: Int = 2
    
    open var minimumColumnSpacing: CGFloat = 10
    
    open var minimumInteritemSpacing: CGFloat = 10
    
    open var sectionHeaderHeight: CGFloat = 0
    
    open var sectionFooterHeight: CGFloat = 0
    
    open var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    
    open var collectionViewHeaderHeight: CGFloat = 0
    
    open var collectionViewFooterHeight: CGFloat = 0
    
    
    fileprivate weak var delegate: LXMWaterfallLayoutDelegate? {
        return self.collectionView?.delegate as? LXMWaterfallLayoutDelegate
    }
    
    fileprivate var contentHeight: CGFloat = 0
    
    /// 这是保存每个section中每个column高度的二维数组，这里用二维数组而不是字典，主要是为了省去字典取值造成的可选绑定
    /// 注意：是column的高度，而不是某个具体cell的高度
    fileprivate var columnHeights = [[CGFloat]]()
    
    /// 保存每个section中每个item的Attributes，也是个二维数组
    fileprivate var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    
    /// 保存sectionHeader的attributes的字典，key是section
    fileprivate var sectionHeaderAttributesDict: [Int : UICollectionViewLayoutAttributes]?
    
    /// 保存sectionFooter的attributes的字典，key是section
    fileprivate var sectionFooterAttributesDict: [Int : UICollectionViewLayoutAttributes]?
    
    fileprivate var collectionViewHeaderAttributes: UICollectionViewLayoutAttributes?
    
    fileprivate var collectionViewFooterAttributes: UICollectionViewLayoutAttributes?
    
    /// 所有item的attributes的数组，包括cell和SectionHeader，SectionFooter,collectionViewHeader,collectionViewFooter
    fileprivate var allAttributesArray = [UICollectionViewLayoutAttributes]()
    
}


// MARK: - override
extension LXMWaterfallLayout {
    
    open override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        let collectionViewWidth = collectionView.bounds.width
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections <= 0 {
            return
        }
        
        self.contentHeight = 0
        self.columnHeights.removeAll()
        self.sectionHeaderAttributesDict = nil
        self.sectionFooterAttributesDict = nil
        self.collectionViewHeaderAttributes = nil
        self.collectionViewFooterAttributes = nil
        self.allAttributesArray.removeAll()
        
        for section in 0 ..< numberOfSections {
            
            //初始化columnHeights这个二维数组，全部赋值0
            var columnHeightArray = [CGFloat]()
            let columnCount = self.columnCount(atSection: section)
            for _ in 0 ..< columnCount {
                columnHeightArray.append(0)
            }
            self.columnHeights.append(columnHeightArray)
            
            //初始化sectionItemAttributes二维数组
            var attributesArray = [UICollectionViewLayoutAttributes]()
            let itemCount = collectionView.numberOfItems(inSection: section)
            for _ in 0 ..< itemCount {
                attributesArray.append(UICollectionViewLayoutAttributes())
            }
            self.sectionItemAttributes.append(attributesArray)
            
            //根据需要初始化sectionHeaderAttributesDict和sectionFooterAttributesDict
            let sectionHeaderHeight = self.sectionHeaderHeight(atSection: section)
            if sectionHeaderHeight > 0 {
                if self.sectionHeaderAttributesDict == nil {
                    self.sectionHeaderAttributesDict = [Int : UICollectionViewLayoutAttributes]()
                }
            }
            
            let sectionFooterHeight = self.sectionFooterHeight(atSection: section)
            if sectionFooterHeight > 0 {
                if self.sectionFooterAttributesDict == nil {
                    self.sectionFooterAttributesDict = [Int : UICollectionViewLayoutAttributes]()
                }
            }
            
        }
        
        //collectionViewHeader
        assert(self.collectionViewHeaderHeight >= 0, "collectionViewHeaderHeight must be equal or greater than 0 !!!")
        if self.collectionViewHeaderHeight > 0 {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindCollectionViewHeader, with: IndexPath())
            attributes.frame = CGRect(x: 0, y: 0, width: collectionViewWidth, height: self.collectionViewHeaderHeight)
            contentHeight = attributes.frame.maxY
            self.collectionViewHeaderAttributes = attributes
            self.allAttributesArray.append(attributes)
        }
        
        
        for section in 0 ..< numberOfSections {
            
            let columnSpacing = self.minimumColumnSpacing(atSection: section)
            let itemSpacing = self.minimumInteritemSpacing(atSection: section)
            let inset = self.sectionInset(atSection: section)
            
            //sectionHeader
            let sectionHeaderHeight = self.sectionHeaderHeight(atSection: section)
            if sectionHeaderHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: contentHeight, width: collectionViewWidth, height: sectionHeaderHeight)
                self.sectionHeaderAttributesDict?[section] = attributes
                contentHeight = attributes.frame.maxY
                self.allAttributesArray.append(attributes)
            }
            
            let itemCount = collectionView.numberOfItems(inSection: section)

            contentHeight += inset.top
            
            //sectionItem
            let columnWidth = self.columnWidth(atSection: section)
            
            for index in 0 ..< itemCount {
                let indexPath = IndexPath(item: index, section: section)
                let columnIndex = self.nextColumnIndexForItem(atIndexPath: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let offsetX = inset.left + CGFloat(columnIndex) * (columnWidth + columnSpacing)
                var offsetY = self.columnHeights[section][columnIndex]
                if offsetY != 0 { //注意，如果offsetY == 0说明是改列第一个，不用加spacing
                    offsetY += itemSpacing
                }
                offsetY += contentHeight
                
                let size = self.itemSize(atIndexPath: indexPath)
                attributes.frame = CGRect(x: offsetX, y: offsetY, width: size.width, height: size.height)
                self.columnHeights[section][columnIndex] = attributes.frame.maxY - contentHeight
                self.sectionItemAttributes[indexPath.section][indexPath.item] = attributes
                self.allAttributesArray.append(attributes)
            }
            
            if let maxColumnHeight = self.columnHeights[section].max() {
                contentHeight += maxColumnHeight
            }
            
            contentHeight += inset.bottom
            
            //sectionFooter
            let sectionFooterHeight = self.sectionFooterHeight(atSection: section)
            if sectionFooterHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: contentHeight, width: collectionViewWidth, height: sectionFooterHeight)
                self.sectionFooterAttributesDict?[section] = attributes
                contentHeight = attributes.frame.maxY
                self.allAttributesArray.append(attributes)
            }
            
        }
        
        //collectionViewFooter
        assert(self.collectionViewFooterHeight >= 0, "collectionViewFooterHeight must be equal or greater than 0 !!!")
        if self.collectionViewFooterHeight > 0 {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LXMCollectionElementKindCollectionViewFooter, with: IndexPath())
            attributes.frame = CGRect(x: 0, y: contentHeight, width: collectionViewWidth, height: self.collectionViewFooterHeight)
            contentHeight = attributes.frame.maxY
            self.collectionViewFooterAttributes = attributes
            self.allAttributesArray.append(attributes)
        }
        

    }
    
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let resultArray = self.allAttributesArray.filter { (tempAttributes) -> Bool in
            return tempAttributes.frame.intersects(rect)
        }
        return resultArray
        
    }
    
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section < self.sectionItemAttributes.count {
            let attributesArray = self.sectionItemAttributes[indexPath.section]
            if indexPath.item < attributesArray.count {
                return attributesArray[indexPath.item]
            }
        }
        return nil
    }
    
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == LXMCollectionElementKindSectionHeader {
            return self.sectionHeaderAttributesDict?[indexPath.section]
        } else if elementKind == LXMCollectionElementKindSectionFooter {
            return self.sectionFooterAttributesDict?[indexPath.section]
        } else if elementKind == LXMCollectionElementKindCollectionViewHeader {
            return self.collectionViewHeaderAttributes
        } else if elementKind == LXMCollectionElementKindCollectionViewFooter {
            return self.collectionViewFooterAttributes
        } else {
            return nil
        }
        
    }
    
    
    open override var collectionViewContentSize: CGSize {
        if let collectionView = self.collectionView {
            return CGSize(width: collectionView.bounds.width, height: self.contentHeight)
        }
        return CGSize.zero
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

// MARK: - PrivateMethod
private extension LXMWaterfallLayout {
    
    func columnCount(atSection section: Int) -> Int {
        if let collectionView = self.collectionView,
            let count = self.delegate?.collectionView?(collectionView, layout: self, numberOfColumnsAt: section) {
            assert(count > 0, "columnCount must be greater than 0 !!!")
            return count
        } else {
            return self.columnCount
        }
    }
    
    func minimumColumnSpacing(atSection section: Int) -> CGFloat {
        if let collectionView = self.collectionView,
            let spacing = self.delegate?.collectionView?(collectionView, layout: self, minimumColumnSpacingForSectionAt: section) {
            assert(spacing >= 0, "minimumColumnSpacing must be equal or greater than 0 !!!")
            return spacing
        } else {
            return self.minimumColumnSpacing
        }
    }
    
    func minimumInteritemSpacing(atSection section: Int) -> CGFloat {
        if let collectionView = self.collectionView,
            let spacing = self.delegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) {
            assert(spacing >= 0, "minimumInteritemSpacing must be equal or greater than 0 !!!")
            return spacing
        } else {
            return self.minimumInteritemSpacing
        }
    }
    
    func sectionHeaderHeight(atSection section: Int) -> CGFloat {
        if let collectionView = self.collectionView,
            let height = self.delegate?.collectionView?(collectionView, layout: self, heightForSectionHeaderInSection: section) {
            assert(height >= 0, "sectionHeaderHeight must be equal or greater than 0 !!!")
            return height
        } else {
            return self.sectionHeaderHeight
        }
    }
    
    func sectionFooterHeight(atSection section: Int) -> CGFloat {
        if let collectionView = self.collectionView,
            let height = self.delegate?.collectionView?(collectionView, layout: self, heightForSectionFooterInSection: section) {
            assert(height >= 0, "sectionFooterHeight must be equal or greater than 0 !!!")
            return height
        } else {
            return self.sectionFooterHeight
        }
    }
    
    func sectionInset(atSection section: Int) -> UIEdgeInsets {
        if let collectionView = self.collectionView,
            let sectionInset = self.delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section) {
            return sectionInset
        } else {
            return self.sectionInset
        }
    }
    
    
    func nextColumnIndexForItem(atIndexPath indexPath: IndexPath) -> Int {
        //这里是直接按 最短优先 来排列，其他的方式感觉意义不大
        var index: Int = 0
        var shortestHeight = CGFloat.greatestFiniteMagnitude
        for (location, tempHeight) in self.columnHeights[indexPath.section].enumerated() {
            if shortestHeight > tempHeight {
                shortestHeight = tempHeight
                index = location
            }
        }
        return index
        
    }
    
    
    func scaledSize(forOriginalSize size: CGSize, limitWidth: CGFloat) -> CGSize {
        if size.width <= 0.01 || size.height <= 0.01 || limitWidth <= 0.01 {
            return CGSize.zero
        }
        let width = floor(limitWidth)
        let height = ceil(width * size.height / size.width)
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - PublicMethod
public extension LXMWaterfallLayout {
    
    public func columnWidth(atSection section: Int) -> CGFloat {
        if let collectionView = self.collectionView {
            let count = self.columnCount(atSection: section)
            let sectionInset = self.sectionInset(atSection: section)
            let spacing = self.minimumColumnSpacing(atSection: section)
            let width = collectionView.bounds.width - sectionInset.left - sectionInset.right
            if count > 1 {
                return floor((width - CGFloat(count - 1) * spacing) / CGFloat(count))
            } else {
                return width
            }
            
        } else {
            return 0
        }
    }
    
    public func itemSize(atIndexPath indexPath: IndexPath) -> CGSize {
        if let collectionView = self.collectionView,
            let itemSize = self.delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) {
            let columnWidth = self.columnWidth(atSection: indexPath.section)
            if itemSize.width == columnWidth {
                return itemSize
            } else {
                return self.scaledSize(forOriginalSize: itemSize, limitWidth: columnWidth)
            }
        } else {
            let columnWidth = self.columnWidth(atSection: indexPath.section)
            return CGSize(width: columnWidth, height: columnWidth)
        }
    }
}



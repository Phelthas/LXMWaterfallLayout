//
//  LXMAlignmentFlowLayout.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/9/1.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit


enum LXMLayoutHorizontalAlignment {

    case left // Visually left aligned

    case center // Visually centered
    
    case right // Visually right aligned
    
    case justified // Fully-justified
}

class LXMAlignmentFlowLayout: UICollectionViewFlowLayout, LXMLayoutHeaderFooterProtocol {

    var horiziontalAlignment: LXMLayoutHorizontalAlignment = .justified
    
    var allAttributesArray = [UICollectionViewLayoutAttributes]()
}

//override
extension LXMAlignmentFlowLayout {
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections <= 0 {
            return
        }
        
        self.sectionItemAttributesDict = [Int : [UICollectionViewLayoutAttributes]]()
        self.sectionHeaderAttributesDict = [Int : UICollectionViewLayoutAttributes]()
        self.sectionFooterAttributesDict = [Int : UICollectionViewLayoutAttributes]()
        self.allAttributesArray.removeAll()
        
        
        for section in 0 ..< numberOfSections {
            var attributesArray = [UICollectionViewLayoutAttributes]()
            for index in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: index, section: section)
                var itemAttributes: UICollectionViewLayoutAttributes?
                itemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
                itemAttributes = self.updateAttributesForHeaderAndFooter(attributes: itemAttributes)
                attributesArray.append(itemAttributes)
            }
            self.sectionItemAttributesDict?[section] = attributesArray.isEmpty ? nil : attributesArray
            self.allAttributesArray.append(contentsOf: attributesArray)
            
            var headerAttributes = super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: section))?.copy() as? UICollectionViewLayoutAttributes
            headerAttributes = self.updateAttributesForHeaderAndFooter(attributes: headerAttributes)
            self.sectionHeaderAttributesDict?[section] = headerAttributes
            var footerAttributes = super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: IndexPath(item: 0, section: section))?.copy() as? UICollectionViewLayoutAttributes
            footerAttributes = self.updateAttributesForHeaderAndFooter(attributes: footerAttributes)
            self.sectionFooterAttributesDict?[section] = footerAttributes
        }
        if self.sectionItemAttributesDict!.isEmpty {
           self.sectionItemAttributesDict = nil
        }
        if self.sectionHeaderAttributesDict!.isEmpty {
            self.sectionHeaderAttributesDict = nil
        }
        if self.sectionFooterAttributesDict!.isEmpty {
            self.sectionFooterAttributesDict = nil
        }

        self.allAttributesArray = self.updateAttributesForAlignment(attributesArray: self.allAttributesArray)
        self.allAttributesArray.append(contentsOf: self.sectionHeaderAttributesDict?.values)
        self.allAttributesArray.append(contentsOf: self.sectionFooterAttributesDict?.values)
        self.allAttributesArray.append(self.collectionViewHeaderAttributes)
        self.allAttributesArray.append(self.collectionViewFooterAttributes)
        
    }
    
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.allAttributesArray?.filter({ (attributes) -> Bool in
            return attributes.frame.intersects(rect)
        })
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.sectionItemAttributesDict?[indexPath.section]?[indexPath.item]
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionElementKindSectionHeader {
            return self.sectionHeaderAttributesDict?[indexPath.section]
        } else if elementKind == UICollectionElementKindSectionFooter {
            return self.sectionFooterAttributesDict?[indexPath.section]
        } else {
            return nil
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


private var kLXMCollectionViewSectionItemAttributesDictKey = "kLXMCollectionViewSectionItemAttributesDictKey"


// MARK: - PrivateMethod
private extension LXMAlignmentFlowLayout {
    
    func sectionInset(atSection section: Int) -> UIEdgeInsets {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: 0) {
                return inset
            }
            
        }
        return self.sectionInset
    }
    
    func groupedArray(attributesArray: [UICollectionViewLayoutAttributes]) -> [[UICollectionViewLayoutAttributes]] {
        var groupArray = [[UICollectionViewLayoutAttributes]]()
        var currentSection: Int = -1
        var currentValue: CGFloat = CGFloat.greatestFiniteMagnitude
        for attributes in attributesArray {
            if attributes.center.y == currentValue {
                groupArray[currentSection].append(attributes)
            } else {
                currentSection += 1
                groupArray.append([UICollectionViewLayoutAttributes]())
                groupArray[currentSection].append(attributes)
                currentValue = attributes.center.y
            }
        }
        return groupArray
    }
    
    func updateAttributesForAlignment(attributesArray: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        let groupArray = self.groupedArray(attributesArray: attributesArray)
        var resultArray = [UICollectionViewLayoutAttributes]()
        for lineArray in groupArray {
            if var currentItem = lineArray.first {
                if currentItem.representedElementKind != nil {
                    resultArray.append(currentItem)
                    continue
                }
                
                currentItem.frame.origin.x = sectionInset(atSection: currentItem.indexPath.section).left
                resultArray.append(currentItem)
                for i in 1 ..< lineArray.count {
                    let attributes = lineArray[i]
                    attributes.frame.origin.x = currentItem.frame.maxX + self.minimumInteritemSpacing
                    resultArray.append(attributes)
                    currentItem = attributes
                }
            }
        }
        return resultArray
        
    }
    
   
}





extension UICollectionViewFlowLayout {
    
    func originalLayoutAttributes() -> [Int : [UICollectionViewLayoutAttributes]]? {
        guard let collectionView = self.collectionView else { return nil }
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections <= 0 {
            return nil
        }
        
        var sectionItemAttributes = [Int : [UICollectionViewLayoutAttributes]]()
        for section in 0 ..< numberOfSections {
            var attributesArray = [UICollectionViewLayoutAttributes]()
            for index in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: index, section: section)
                var itemAttributes: UICollectionViewLayoutAttributes?
                itemAttributes = super.layoutAttributesForItem(at: indexPath)
                attributesArray.append(itemAttributes)
            }
            sectionItemAttributes[section] = attributesArray.isEmpty ? nil : attributesArray
        }
        return sectionItemAttributes.isEmpty ? nil : sectionItemAttributes
    }
    
}





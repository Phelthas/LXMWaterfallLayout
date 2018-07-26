//
//  HeaderFooterViewController.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/26.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit

class HeaderFooterViewController: DemoBaseViewController {
    var scrollDirection: UICollectionViewScrollDirection = .vertical
}

// MARK: - Lifecycle
extension HeaderFooterViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout = UICollectionViewFlowLayout()
        let layout = LXMHeaderFooterFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        layout.collectionViewHeaderHeight = 200
        layout.collectionViewFooterHeight = 300
        layout.scrollDirection = self.scrollDirection
        
        self.collectionView.collectionViewLayout = layout
        
        let sectionNib = UINib(nibName: "TestSectionView", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: TestSectionViewIdentifier)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: TestSectionViewIdentifier)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: LXMCollectionElementKindHeader , withReuseIdentifier: TestSectionViewIdentifier)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: LXMCollectionElementKindFooter, withReuseIdentifier: TestSectionViewIdentifier)

//        collectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        
        
        
        let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(changeAlignment))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func changeAlignment() {
        if let layout = self.collectionView.collectionViewLayout as? LXMHeaderFooterFlowLayout {
            
            if self.scrollDirection == .vertical {
                if layout.horiziontalAlignment == .left {
                    layout.horiziontalAlignment = .right
                } else if layout.horiziontalAlignment == .right {
                    layout.horiziontalAlignment = .center
                } else if layout.horiziontalAlignment == .center {
                    layout.horiziontalAlignment = .justified
                } else if layout.horiziontalAlignment == .justified {
                    layout.horiziontalAlignment = .none
                } else if layout.horiziontalAlignment == .none {
                    layout.horiziontalAlignment = .left
                }
                
            } else {
                if layout.verticalAlignment == .top {
                    layout.verticalAlignment = .bottom
                } else if layout.verticalAlignment == .bottom {
                    layout.verticalAlignment = .center
                } else if layout.verticalAlignment == .center {
                    layout.verticalAlignment = .justified
                } else if layout.verticalAlignment == .justified {
                    layout.verticalAlignment = .none
                } else if layout.verticalAlignment == .none {
                    layout.verticalAlignment = .top
                }
            }
            self.collectionView.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HeaderFooterViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TestSectionViewIdentifier, for: indexPath) as! TestSectionView
            sectionView.backgroundColor = UIColor.red
            sectionView.nameLabel.text = "sectionHeader \(indexPath.section)"
            return sectionView
            
        } else if kind == UICollectionElementKindSectionFooter {
            let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TestSectionViewIdentifier, for: indexPath) as! TestSectionView
            sectionView.backgroundColor = UIColor.blue
            sectionView.nameLabel.text = "sectionFooter \(indexPath.section)"
            return sectionView
        } else if kind == LXMCollectionElementKindHeader {
            let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TestSectionViewIdentifier, for: indexPath) as! TestSectionView
            sectionView.backgroundColor = UIColor.yellow
            sectionView.nameLabel.text = "collectionViewHeader"
            return sectionView
        } else if kind == LXMCollectionElementKindFooter {
            let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TestSectionViewIdentifier, for: indexPath) as! TestSectionView
            sectionView.backgroundColor = UIColor.green
            sectionView.nameLabel.text = "collectionViewFooter"
            return sectionView
        } else {
            return UICollectionReusableView()
        }
    }
}

extension HeaderFooterViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return sizeArray[indexPath.item]
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 100, height: 30)
        } else if section == 1 {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize.zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 100, height: 30)
        } else if section == 1 {
            return CGSize(width: 100, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
}

extension HeaderFooterViewController {
    
    
}

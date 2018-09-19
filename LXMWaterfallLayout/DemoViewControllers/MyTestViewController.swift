//
//  MyTestViewController.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/9/6.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit

class MyTestViewController: DemoBaseViewController {

}


// MARK: - Lifecycle
extension MyTestViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = MyTestLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        layout.collectionViewHeaderHeight = 200
        layout.collectionViewFooterHeight = 300
        
        self.collectionView.collectionViewLayout = layout
        
        let sectionNib = UINib(nibName: "TestSectionView", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: TestSectionViewIdentifier)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: TestSectionViewIdentifier)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: LXMCollectionElementKindHeader , withReuseIdentifier: TestSectionViewIdentifier)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: LXMCollectionElementKindFooter, withReuseIdentifier: TestSectionViewIdentifier)
        
        //        collectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyTestViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TestSectionViewIdentifier, for: indexPath) as! TestSectionView
            sectionView.backgroundColor = UIColor.red
            sectionView.nameLabel.text = "sectionHeader \(indexPath.section)"
            return sectionView
            
        } else if kind == UICollectionView.elementKindSectionFooter {
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

extension MyTestViewController: UICollectionViewDelegateFlowLayout {
    
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

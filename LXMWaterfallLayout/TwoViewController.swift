//
//  TwoViewController.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/25.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit

class TwoViewController: UIViewController {
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "TestCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: TestCollectionViewCellIdentifier)
        
        let sectionNib = UINib(nibName: "TestSectionView", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: TestSectionViewIdentifier)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: TestSectionViewIdentifier)
        return collectionView
    }()
    
    
    fileprivate var dataArray: [String] = {
        var dataArray = [String]()
        for i in 0 ..< 20 {
            dataArray.append("\(i)")
        }
        return dataArray
    }()
    
    fileprivate var sizeArray: [CGSize] = {
        var sizeArray = [CGSize]()
        for i in 0 ..< 20 {
            sizeArray.append(CGSize(width: 100, height: 100 + i % 5 * 10))
        }
        return sizeArray
    }()


}

// MARK: - Lifecycle
extension TwoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - UICollectionViewDataSource
extension TwoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return dataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCellIdentifier, for: indexPath) as! TestCollectionViewCell
        cell.nameLabel.text = "(\(indexPath.section),\(dataArray[indexPath.item]))"
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
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
        } else {
            return UICollectionReusableView()
        }
    }
}


// MARK: - UICollectionViewDelegate
extension TwoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            self.collectionView.reloadData()
        }
        
        print("didSelectItemAt \(indexPath)")
    }
}

extension TwoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeArray[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 20
        } else if section == 1 {
            return 10
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 20
        } else if section == 1 {
            return 10
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 100, height: 0)
        } else if section == 1 {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize.zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 100, height: 0)
        } else if section == 1 {
            return CGSize(width: 100, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else if section == 1 {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
}

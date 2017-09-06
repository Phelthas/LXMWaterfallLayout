//
//  DemoBaseViewController.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/26.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit

class DemoBaseViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "TestCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: TestCollectionViewCellIdentifier)
        return collectionView
    }()
    
    
    var dataArray: [String] = {
        var dataArray = [String]()
        for i in 0 ..< 20 {
            dataArray.append("\(i)")
        }
        return dataArray
    }()
    
    var sizeArray: [CGSize] = {
        var sizeArray = [CGSize]()
        for i in 0 ..< 20 {
            sizeArray.append(CGSize(width: 100, height: 100 + i % 5 * 10))
        }
        return sizeArray
    }()
    
}


// MARK: - Lifecycle
extension DemoBaseViewController {
    
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
extension DemoBaseViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            return 5
        } else if section == 1 {
            return 10
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
    
    
}


// MARK: - UICollectionViewDelegate
extension DemoBaseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath)")
        
    }
}




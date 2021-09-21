//
//  HorizontalMenuViewController.swift
//  LXMWaterfallLayout
//
//  Created by billthaslu on 2021/9/12.
//  Copyright © 2021 duowan. All rights reserved.
//

import UIKit

class HorizontalMenuViewController: DemoBaseViewController {


}


// MARK: - Lifecycle
extension HorizontalMenuViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = LXMHorizontalMenuLayout()
        layout.interitemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.dataArray = ["电影", "电视剧", "动画", "短视频", "漫画", "游戏"]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 44)
    }

}


// MARK: - override
extension HorizontalMenuViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//        return 2
//        return 3
        return 4
        return self.dataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCellIdentifier, for: indexPath) as! TestCollectionViewCell
        cell.nameLabel.text = self.dataArray[indexPath.item]
        cell.nameLabel.textAlignment = .center
        cell.backgroundColor = UIColor.orange
        return cell
    }
}


extension HorizontalMenuViewController: LXMHorizontalMenuLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMHorizontalMenuLayout, sizeForItemAt index: Int) -> CGSize {
        return CGSize(width: 100, height: 44)
    }
}

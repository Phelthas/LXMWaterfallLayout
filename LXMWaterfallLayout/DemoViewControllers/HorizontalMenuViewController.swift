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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    

}


// MARK: - override
extension HorizontalMenuViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
//        return 2
//        return 3
//        return 4
    }
}


extension HorizontalMenuViewController: LXMHorizontalMenuLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: LXMHorizontalMenuLayout, sizeForItemAt index: Int) -> CGSize {
        return sizeArray[index]
    }
}

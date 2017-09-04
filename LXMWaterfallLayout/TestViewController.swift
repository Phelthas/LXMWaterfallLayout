//
//  TestViewController.swift
//  LXMWaterfallLayout
//
//  Created by luxiaoming on 2017/8/26.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit

class TestViewController: DemoBaseViewController {

}


// MARK: - Lifecycle
extension TestViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout = collectionView.collectionViewLayout 
        
        
        var dict: [Int : String] = [0 : "a",
                                    1 : "b",
                                    2 : "c"]
        
        dict[1] = nil
        
        var array: [String?] = ["a", "b", "c", nil]
        
        array.append(nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

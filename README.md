# LXMWaterfallLayout
A collectionViewLayout layout cells like waterfall, which add the missing collectionViewHeader and collectionViewFooter.

LXMWaterfallLayout is inspired by [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout), and made several improvements to make it easier to use. It is subclass of UICollectionViewLayout and it's usage is just like UICollectionViewFlowLayout.    

![screenshot](https://github.com/Phelthas/LXMWaterfallLayout/blob/master/ScreenShots/LXMWaterfallLayout.gif)

[传送门](http://www.jianshu.com/p/82daa5db4a74)和[传送门](http://www.jianshu.com/p/21f97112cc8e)是我写的总结
## Requirements
Swift3.0 +   
Xcode8.0 +    



## Install
1, CocoaPods    
   add `pod 'LXMWaterfallLayout'` to your podfile and run `pod install`    
2, Manual    
   drag `LXMWaterfallLayout.swift` into your project 


## Updates

1.0.6    
* add `LXMHorizontalMenuLayout`;    


1.0.4
* update to Swift4.2，Swift4.1 and before please use 1.0.3

1.0.3    
* Fix a bug    

1.0.0    
* Add `horiziontalAlignment` and `verticalAlignment` property, which make `LXMWaterfallLayout` supports alignment now;    
* Add support for `UICollectionViewScrollDirection.horizontal`    

0.0.4  
* Fix bugs with contentInset    

0.0.3  
* Add `LXMLayoutHeaderFooterProtocol` and `LXMHeaderFooterFlowLayout`    
Now both `LXMHeaderFooterFlowLayout` and `LXMWaterfallLayout` confirm to `LXMLayoutHeaderFooterProtocol` so the architecture is more clear, what's more, if you have your own collectionViewLayout and you want it to have a header or footer too, you can complete it in minutes by adopting `LXMLayoutHeaderFooterProtocol`
      

## How to use
It is just like UICollectionViewFlowLayout, all you have to do is `LXMWaterfallLayout()` and assign it to a collectionView

## Issues
```
if (find any bug || have any problem) {
   feel free to open an issue or pull request
} else {
   star it if it helps
}
```
I will try my best to help as soon as I see it~

## License
LXMWaterfallLayout is available under the MIT license. See the LICENSE file for more info.


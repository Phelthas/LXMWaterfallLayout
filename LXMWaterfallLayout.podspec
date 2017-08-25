Pod::Spec.new do |s|
  s.name         = "LXMWaterfallLayout"
  s.version      = "0.0.1"
  s.summary      = "A collectionViewLayout layout cells like waterfall, which add the missing collectionViewHeader and collectionViewFooter"
  s.description  = <<-DESC
A collectionViewLayout layout cells like waterfall, which add the missing collectionViewHeader and collectionViewFooter.

LXMWaterfallLayout is inspired by CHTCollectionViewWaterfallLayout, and made several improvements to make it easier to use. It is subclass of UICollectionViewLayout and it's usage is just like UICollectionViewFlowLayout.                   
DESC
  s.homepage     = "https://github.com/Phelthas/LXMWaterfallLayout"
  s.license      = "MIT"
  s.author       = { "Phelthas" => "billthas@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Phelthas/LXMWaterfallLayout.git", :tag => "0.0.1" }
  s.source_files  = "LXMWaterfallLayout/LXMWaterfallLayout/*.swift"
  s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "OJASwiftKitDemo/OJASwiftKit/**/*.swift"
  # s.resources = "Resources/*.png"
  s.frameworks = "Foundation", "UIKit"
  # s.libraries = "iconv", "xml2"
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end

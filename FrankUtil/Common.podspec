
Pod::Spec.new do |s|
  s.name         = "Common"
  s.version      = "1.0.0"
  s.summary      = "A short description of Common."
  
  s.platform     = :ios, "5.1.1"

  s.homepage     = "http://EXAMPLE/Common"
  s.license      = "MIT"
  s.author             = { "frank" => "frank.zhang@laba.cn" }
  s.source       = { :git => "http://phabricator.weichaishi.com/diffusion/CI/common-ios.git", :tag => "v1.0.0" }

  s.requires_arc = true

  s.subspec "WCSCategory" do |cs|
	  cs.source_files = "CategoryUtil/CategoryUtil/Category/**/*.{h,m}"
	  cs.public_header_files = "CategoryUtil/CategoryUtil/Category/**/*.h"
	  cs.frameworks = "UIKit", "Foundation"
  end
 
  s.subspec "WCSTools" do |ts|
	  ts.subspec "AESCrypt" do |at|
	 	  at.source_files = "CategoryUtil/CategoryUtil/CustomUtil/AESCrypt/**/*.{h,m}"
	 	  at.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/AESCrypt/**/*.h"
	 	  at.frameworks = "Foundation"
	 	  at.dependency "Common/WCSCategory"
	  end
		  
	  ts.subspec "DDProgressView" do |dt|
	 	  dt.source_files = "CategoryUtil/CategoryUtil/CustomUtil/DDProgressView/**/*.{h,m}"
	 	  dt.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/DDProgressView/**/*.h"
	 	  dt.frameworks = "UIKit"
	  end
	  
	  ts.subspec "ImageService" do |it|
	 	  it.source_files = "CategoryUtil/CategoryUtil/CustomUtil/ImageService/**/*.{h,m}"
	 	  it.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/ImageService/**/*.h"
	 	  it.frameworks = "UIKit","Foundation"
		  it.dependency "Common/WCSCategory"
	  end
	  
	  ts.subspec "QLoadingView" do |qt|
	 	  qt.source_files = "CategoryUtil/CategoryUtil/CustomUtil/QLoadingView/**/*.{h,m}"
	 	  qt.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/QLoadingView/**/*.h"
	 	  qt.frameworks = "UIKit","Foundation"
	  end
		  
	  ts.subspec "VideoService" do |vt|
	 	  vt.source_files = "CategoryUtil/CategoryUtil/CustomUtil/VideoService/**/*.{h,m}"
	 	  vt.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/VideoService/**/*.h"
	 	  vt.frameworks = "UIKit","Foundation","AssetsLibrary","QuartzCore"
	  end
	  
	  ts.subspec "HFRequest" do |ht|
	 	  ht.source_files = "CategoryUtil/CategoryUtil/CustomUtil/HFRequest/**/*.{h,m}"
	 	  ht.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/HFRequest/**/*.h"
	 	  ht.frameworks = "UIKit","Foundation"
	  end
	  
	  ts.subspec "pinyin" do |pt|
	 	  pt.source_files = "CategoryUtil/CategoryUtil/CustomUtil/pinyin/**/*.{h,m}"
	 	  pt.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/pinyin/**/*.h"
	 	  pt.frameworks = "Foundation"
	  end
	  
	  ts.subspec "SqliteCore" do |st|
	 	  st.source_files = "CategoryUtil/CategoryUtil/CustomUtil/SqliteCore/**/*.{h,m}"
	 	  st.public_header_files = "CategoryUtil/CategoryUtil//CustomUtil/SqliteCore/**/*.h"
	 	  st.frameworks = "Foundation"
		  st.libraries = "sqlite3"
	  end
  end
 
  s.subspec "WCSLibs" do |ls|
	  ls.subspec "Lame" do |ll|
	 	  ll.source_files = "CategoryUtil/CategoryUtil/Libs/Lame/**/*.{h,m}"
	 	  ll.public_header_files = "CategoryUtil/CategoryUtil//Libs/Lame/**/*.h"
		  ll.preserve_paths = "CategoryUtil/CategoryUtil/Libs/Lame"
		  ll.vendored_libraries = "**/*.a"
		  ll.frameworks = "UIKit", "Foundation", "AVFoundation"
	  end
	  
	  ls.subspec "AudioCore" do |al|
	 	  al.source_files = "CategoryUtil/CategoryUtil/Libs/AudioCore/**/*.{h,m}"
	 	  al.public_header_files = "CategoryUtil/CategoryUtil//Libs/AudioCore/**/*.h"
	 	  al.frameworks = "UIKit", "Foundation", "AVFoundation"
		  al.dependency "Common/WCSLibs/Lame"
	  end
	  
	  ls.subspec "Badge" do |bl|
	 	  bl.source_files = "CategoryUtil/CategoryUtil/Libs/Badge/**/*.{h,m}"
	 	  bl.public_header_files = "CategoryUtil/CategoryUtil//Libs/Badge/**/*.h"
	 	  bl.frameworks = "UIKit", "Foundation"
	  end
	  
	  ls.subspec "CycleScrollView" do |cl|
	 	  cl.source_files = "CategoryUtil/CategoryUtil/Libs/CycleScrollView/**/*.{h,m}"
	 	  cl.public_header_files = "CategoryUtil/CategoryUtil//Libs/CycleScrollView/**/*.h"
	 	  cl.frameworks = "UIKit", "Foundation"
	  end
	  
	  ls.subspec "EGORefresh" do |el|
	 	  el.source_files = "CategoryUtil/CategoryUtil/Libs/EGORefresh/**/*.{h,m}"
	 	  el.public_header_files = "CategoryUtil/CategoryUtil//Libs/EGORefresh/**/*.h"
	 	  el.frameworks = "UIKit", "Foundation"
	  end
	  
	  ls.subspec "PageControl" do |pcl|
	 	  pcl.source_files = "CategoryUtil/CategoryUtil/Libs/PageControl/**/*.{h,m}"
	 	  pcl.public_header_files = "CategoryUtil/CategoryUtil//Libs/PageControl/**/*.h"
	 	  pcl.frameworks = "UIKit", "Foundation"
	  end
	  
	  ls.subspec "pop" do |pl|
	 	  pl.source_files = "CategoryUtil/CategoryUtil/Libs/pop/**/*.{h,m}"
	 	  pl.public_header_files = "CategoryUtil/CategoryUtil//Libs/pop/**/*.h"
	 	  pl.frameworks = "UIKit", "Foundation"
	  end

	  ls.subspec "WSCoachMarksView" do |cml|
	 	  cml.source_files = "CategoryUtil/CategoryUtil/Libs/WSCoachMarksView/**/*.{h,m}"
	 	  cml.public_header_files = "CategoryUtil/CategoryUtil//Libs/WSCoachMarksView/**/*.h"
	 	  cml.frameworks = "UIKit", "Foundation"
	  end
  end
end

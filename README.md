# QRCodeDemo
QRCodeDemo 是利用AVFounation 框架，做的一个简易二维码扫描Demo，仅供学习参考.

Swift3.1 + XCode8.3

二维码扫描最主要的部分：

在实际项目开发过程中，我们还会遇到系统权限调用问题，以前在做项目的时候不知道大家有没有遇到，就是第一次启动App的时候，访问权限，会弹出系统权限选择，也就是在Info.plist设置的，如果在这里处理不好，会有Bug,目前可以采用的一个避免方法。

/// ① 判断系统权限
private let captureAuth   = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

第一次启动App,captureAuth == AVAuthorizationStatus.notDetermined,此时，因为系统没有给App这个相机访问权限，所以可能会导致当前页面一片漆黑。

// ios7.0的方法，isBool值会截获系统弹出框，用户的选择，根据选择，跳转设置或者退出等操作！

_ = AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (isBool) in
            
        })

/// ② 限制二维码扫描区域，系统的扫描方式使用 AVCaptureMetadataOutput 对象，

captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

// 匹配扫描二维码

captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

metadataObjectTypes，是一个数组，可以同时支持扫描二维码，条形码等，这里只使用二维码。

AVCaptureMetadataOutput 有一个 rectOfInterest属性，该属性就是限制扫描的区域，依据官方文档解释，rectOfInterest.CGRect = (x:0., y:0, width:1, height:1),所有值都在这个范围之内。

经过验证其原点在屏幕的右上角。具体可以下载代码自己去试试

代码持续更新中。。。。。。

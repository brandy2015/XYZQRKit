
import UIKit


public protocol QQScanViewControllerDelegate: class {
    func Result(_ controller: QQScanViewController, didFinishGet ScanResults: [LBXScanResult])
    func Result(_ controller: QQScanViewController)
}

public class QQScanViewController: LBXScanViewController {
    //声明代理
    weak var Resultdelegate: QQScanViewControllerDelegate? = nil
    var topTitle: UILabel?      /**@brief  扫码区域上方提示文字*/
    var isOpenedFlash: Bool = false/** @brief  闪关灯开启状态*/
    // MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    //底部显示的功能项
    var bottomItemsView: UIView?
    var btnPhoto: UIButton = UIButton()//相册
    var btnFlash: UIButton = UIButton()//闪光灯
    var btnMyQR: UIButton = UIButton()//我的二维码
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: false)
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
        // Do any additional setup after loading the view.
    }
    
    @available(iOS, deprecated: 13.0)
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawBottomItems()
    }
    
    //识别结果
    override public func handleCodeResult(arrayResult: [LBXScanResult]) {
        Resultdelegate?.Result(self, didFinishGet: arrayResult)
    }
    
    func drawBottomItems() {
        if (bottomItemsView != nil) {return}
        let yMax = self.view.frame.maxY - self.view.frame.minY
        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100))
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        self.view.addSubview(bottomItemsView!)
        let size = CGSize(width: 65, height: 87)
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)
        btnFlash.setImage(ImageInBundle(WithName: "qrcode_scan_btn_flash_nor@2x"), for:.normal)
        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControl.Event.touchUpInside)
        
        self.btnMyQR = UIButton()
        btnMyQR.bounds = btnFlash.bounds;
        btnMyQR.center = CGPoint(x: bottomItemsView!.frame.width * 3/4, y: bottomItemsView!.frame.height/2);
        btnMyQR.setImage(ImageInBundle(WithName: "CloseBTN@2x"), for: .normal)
        btnMyQR.setImage(ImageInBundle(WithName: "CloseBTN@2x"), for: .highlighted)
        btnMyQR.addTarget(self, action: #selector(QQScanViewController.dismissVC), for: UIControl.Event.touchUpInside)
        
        
        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnMyQR)
        self.view.addSubview(bottomItemsView!)
    }
    
    
    func ImageInBundle(WithName named:String) -> UIImage {
        let bundlePath = Bundle(for: self.classForCoder).bundlePath + "/CodeScan.bundle"
        let bundleXX = Bundle(path: bundlePath)!
        return UIImage(named: named, in: bundleXX, compatibleWith: nil)!
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        XYZResponse.D点按马达震动反馈(style: .heavy)
        scanObj?.changeTorch()
        isOpenedFlash = !isOpenedFlash
        
        let flash_downImage = ImageInBundle(WithName: "qrcode_scan_btn_flash_down@2x")
        let flash_nor       = ImageInBundle(WithName: "qrcode_scan_btn_flash_nor@2x")
        btnFlash.setImage(isOpenedFlash ? flash_downImage : flash_nor, for:.normal)
    }
    
    @objc func dismissVC(){
        XYZResponse.D点按马达震动反馈(style: .medium)
//        Resultdelegate?.Result(self)
        dismiss(animated: true, completion: nil)
    }
    private class XYZResponse: NSObject {
        /// 创建枚举
        public enum FeedbackType: Int {case light,medium,heavy,success,warning,error,none}
        
        /// 创建类方法，随时调用
        public static func D点按马达震动反馈(style: FeedbackType) {
            let generator = UINotificationFeedbackGenerator()
            switch style {
            case .light  :let generator = UIImpactFeedbackGenerator(style: .light)    ;generator.impactOccurred()
            case .medium :let generator = UIImpactFeedbackGenerator(style: .medium)   ;generator.impactOccurred()
            case .heavy  :let generator = UIImpactFeedbackGenerator(style: .heavy)    ;generator.impactOccurred()
            case .success:generator.notificationOccurred(.success)
            case .warning:generator.notificationOccurred(.warning)
            case .error  :generator.notificationOccurred(.error)
            default:break
            }
        }
        
    }
}




//public protocol QQScanViewControllerDelegate: class {
//    //    func ChooseIconTVCDidCancel(_ controller: ChooseIconTVC)
//    func Result(_ controller: QQScanViewController, didFinishGet ScanResults: [LBXScanResult])
//
//    func Result(_ controller: QQScanViewController)
//}
//
//public class QQScanViewController: LBXScanViewController {
//
//    //声明代理
//    weak var Resultdelegate: QQScanViewControllerDelegate? = nil
//
//
//    var topTitle: UILabel?      /**@brief  扫码区域上方提示文字*/
//    var isOpenedFlash: Bool = false/** @brief  闪关灯开启状态*/
//    // MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
//    //底部显示的功能项
//    var bottomItemsView: UIView?
//    //相册
//    var btnPhoto: UIButton = UIButton()
//    //闪光灯
//    var btnFlash: UIButton = UIButton()
//    //我的二维码
//    var btnMyQR: UIButton = UIButton()
//
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        //需要识别后的图像
//        setNeedCodeImage(needCodeImg: false)
//        //框向上移动10个像素
//        scanStyle?.centerUpOffset += 10
//        // Do any additional setup after loading the view.
//    }
//
//    override public func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        drawBottomItems()
//    }
//
//    //识别结果
//    override public func handleCodeResult(arrayResult: [LBXScanResult]) {
//        Resultdelegate?.Result(self, didFinishGet: arrayResult)
//    }
//
//    func drawBottomItems() {
//        if (bottomItemsView != nil) {return}
//        let yMax = self.view.frame.maxY - self.view.frame.minY
//        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100))
//        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
//        self.view .addSubview(bottomItemsView!)
//        let size = CGSize(width: 65, height: 87)
//        self.btnFlash = UIButton()
//        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)
//        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
//        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControl.Event.touchUpInside)
//
////        self.btnPhoto = UIButton()
////        btnPhoto.bounds = btnFlash.bounds
////        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/4, y: bottomItemsView!.frame.height/2)
////
////        let img = UIImage(named: "CloseBTN")
////        btnPhoto.setImage(img, for: UIControl.State.normal)
////
////        btnPhoto.setImage(img, for: UIControl.State.highlighted)
////        btnPhoto.addTarget(self, action: Selector(("openPhotoAlbum")), for: UIControl.Event.touchUpInside)
//        //        btnPhoto.addTarget(self, action: Selector(("openPhotoAlbum")), for: UIControlEvents.touchUpInside)
////        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControl.State.normal)
////        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControl.State.highlighted)
////        btnPhoto.addTarget(self, action: Selector(("openPhotoAlbum")), for: UIControlEvents.touchUpInside)
//
////        btnPhoto.addTarget(self, action: #selector(QQScanViewController.dismissVC), for: UIControl.Event.touchUpInside)
//
//        self.btnMyQR = UIButton()
//        btnMyQR.bounds = btnFlash.bounds;
//        btnMyQR.center = CGPoint(x: bottomItemsView!.frame.width * 3/4, y: bottomItemsView!.frame.height/2);
//
//        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/CloseBTN@2x"), for: .normal)
//        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/CloseBTN@2x"), for: .highlighted)
////        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"), for: UIControl.State.normal)
////        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_down"), for: UIControl.State.highlighted)
////        btnMyQR.addTarget(self, action: #selector(QQScanViewController.myCode), for: UIControl.Event.touchUpInside)
//        //
//        btnMyQR.addTarget(self, action: #selector(QQScanViewController.dismissVC), for: UIControl.Event.touchUpInside)
//        bottomItemsView?.addSubview(btnFlash)
//        bottomItemsView?.addSubview(btnMyQR)
//        self.view .addSubview(bottomItemsView!)
//    }
//
//
//
//    //开关闪光灯
//    @objc func openOrCloseFlash() {
////        XYZResponse.D点按马达震动反馈(style: .heavy)
//        scanObj?.changeTorch()
//        isOpenedFlash = !isOpenedFlash
//        let flash_downImage = UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down")
//        let flash_nor       = UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor")
//        btnFlash.setImage(isOpenedFlash ? flash_downImage : flash_nor, for:.normal)
//    }
//
//
//    @objc func dismissVC(){
////        XYZResponse.D点按马达震动反馈(style: .medium)
//        Resultdelegate?.Result(self)
//        dismiss(animated: true, completion: nil)
//    }
//    //    @objc func myCode() {PresentVC(With: "ProduceQRCodeID")}
//}

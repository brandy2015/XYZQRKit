//
//  XYZQRKit.swift
//  XYZQRKit
//
//  Created by 张子豪 on 2018/12/18.
//  Copyright © 2018 张子豪. All rights reserved.
//

import UIKit
import EFQRCode
import MobileCoreServices            //picker.mediaTypes的类型
import PhotosUI                      //LivePhoto使用的依赖库
//import SHPathManager
import XYZPathKit
import FileKit
import SoHow

public class XYZQRKit:NSObject{}
//Scan
public extension UIImage{
    
    func ScanQRToString(completion: @escaping ((_ BackData: [String]?) -> Void))  {
        guard let testImage = self.cgImage ,let tryCodes = EFQRCode.recognize(image: testImage) ,tryCodes.count > 0 else{completion(nil);return}
        completion(tryCodes)
    }
    
    
}

//Generate
public extension UIImage{
    func ImgToQR(WithString:String,icon:UIImage?,completion: @escaping ((_ BackQR: UIImage?) -> Void)){
        
        guard let tryImage = EFQRCode.generate(content: WithString,watermark: self.cgImage,icon: icon?.cgImage ) else{completion(nil);return}
        completion(UIImage(cgImage: tryImage))
    }
    
}

//Generate With GIFData
public extension Data{
    func GIFToQR(WithString:String,icon:UIImage?,completion: @escaping ((_ GIFData: Data?,_ GIfURL: URL?) -> Void)){
        let URLPath = userCookies + (UUID().uuidString + ".gif")
        let generator = EFQRCodeGenerator(content: WithString)
        
        generator.setIcon(icon: icon?.cgImage, size: nil)
        
        guard let qrcodeData = EFQRCode.generateWithGIF(data: self, generator: generator) else{ completion(nil,nil);return}
        do { try qrcodeData.write(to: URLPath)
            completion(qrcodeData,URLPath.url)
        }catch{completion(nil, nil)}
    }
}


//GenerateQR With String
public extension String{
    func StringToQR(size:CGSize = CGSize(width: 1024, height: 1024),QRColor:UIColor = UIColor.black,BackColor:UIColor = UIColor.white,logoImg:UIImage?,logosize:CGSize?,completion: @escaping ((_ BackQR: UIImage?) -> Void)){
        guard let QRImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator",codeString:self, size: size, qrColor: QRColor, bkColor: BackColor) else{completion(nil);return}
        if let logoImg = logoImg{
            let imageX = LBXScanWrapper.addImageLogo(srcImg: QRImg, logoImg: logoImg, logoSize:logosize ??  CGSize(width: size.width / 4, height: size.height / 4))
            completion(imageX)
        }else{ completion(QRImg)}
        
    }
    
}

//GenerateBarCode With String
public extension String{
    func StringToBarCode(size:CGSize,BarCodeColor:UIColor = .black,BarBackColor:UIColor = .white,completion: @escaping ((_ BackQR: UIImage?) -> Void)){
        let qrImg = LBXScanWrapper.createCode128(codeString: self, size:size, qrColor: BarCodeColor, bkColor: BarBackColor)
        completion(qrImg)
    }
}

public extension URL{
     func savePicOrGIFToAlbum()  {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: self)
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {print("保存成功")} else{ print("保存失败：", error!.localizedDescription)}
        }
    }
    
    func saveVideoToAlbum(){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self)
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {print("保存成功")} else{ print("保存失败：", error!.localizedDescription)}
        }
    }
}
public extension UIImage{
    func savePicOrGIFToAlbum()  {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {print("保存成功")} else{ print("保存失败：", error!.localizedDescription)}
        }
    }
}

//XYZQRKit需要

public extension UIImageView{
    func addLongPressToSave() {
        let guesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_ :)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(guesture)
    }
    @objc func longPress(_ gusture:UILongPressGestureRecognizer){print("长按了")// 检测手势阶段
        switch gusture.state {
        case .began:XYZResponse.D点按马达震动反馈(style: .heavy);print("开始点按")
        case .ended:print("停止点按");XYZResponse.D点按马达震动反馈(style: .heavy)
        guard let img = self.image else{print("没有照片");return}
        XYZResponse.D点按马达震动反馈(style: .heavy)
        
        
            img.SaveToAlbum { (Succeedx, error) in
                if let error = error{
                    print(error)
                }else if Succeedx{
                    DispatchQueue.main.async {
                        XYZJump.To.Album();print("弹出是否保存")
                    }
                }
            }
        
            
            
            
        default: print("没有照片")
        }
        
    }
//    @objc func longPress(_ gusture:UILongPressGestureRecognizer){print("长按了")// 检测手势阶段
//        switch gusture.state {
//            case .began:XYZResponse.D点按马达震动反馈(style: .heavy);print("开始点按")
//            case .ended:print("停止点按");XYZResponse.D点按马达震动反馈(style: .heavy)
//                    guard let img = self.image else{print("没有照片");return}
//                    XYZResponse.D点按马达震动反馈(style: .heavy)
//            img.SaveToAlbum { (Succeedx, error) in
//                if let error = error{
//                    print(error)
//                }else if Succeedx{
//                    XYZJump.To.Album();print("弹出是否保存")
//                }
//            }
//
//            default: print("没有照片")
//        }
//    }
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


//public extension UIView{
//    public var width :CGFloat { return self.frame.width  }
//    public var height:CGFloat { return self.frame.height }
//    
//    public func widthX(_ separateBy:Double) -> CGFloat {
//        return self.frame.width * CGFloat(separateBy)
//    }
//    public func height(_ separateBy:Double) -> CGFloat {
//        return self.frame.height * CGFloat(separateBy)
//    }
//    public func addShadow(backgroundColor:UIColor = UIColor.white){
//        self.backgroundColor = backgroundColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowRadius = 2
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.5
//    }
//    public func addImage(UIImageX:UIImage?){
//        let RectX = CGRect(x: 0, y: 0, width: self.width, height: self.height)
//        let x = UIImageView(frame: RectX)
//        x.image = UIImageX
//        self.addSubview(x)
//    }
//}



//
//    public func 添加二维码createQR1(rect:CGRect,InstoryboardBackView: UIView,codeType:String = "CIQRCodeGenerator",生成内容:String,大小尺寸CGRect:CGRect? = nil,二维码颜色:UIColor = UIColor.black,背景颜色:UIColor = UIColor.white,logoImage:UIImage? = UIImage() ,logosize:CGSize = CGSize(width: 30, height: 30)){
//
//        let QRImageView二维码imageView = UIImageView()
//        QRImageView二维码imageView.frame = rect
//        let sizex = QRImageView二维码imageView.bounds.size
//        //系统自带能生成的码
//        //        CIAztecCodeGenerator
//        //        CICode128BarcodeGenerator
//        //        CIPDF417BarcodeGenerator
//        //        CIQRCodeGenerator
//
//
//
//        //        var 大小尺寸x = CGSize()
//        //        if let 大小尺寸 = 大小尺寸CGSize{
//        //            大小尺寸x = 大小尺寸
//        //        }
//        //        if let 大小尺寸2 = 大小尺寸CGRect{
//        //            let QRImageView二维码imageView = UIImageView()
//        //            //设定一个大小
//        //
//        //            QRImageView二维码imageView.frame = 大小尺寸2
//        //            大小尺寸x = QRImageView二维码imageView.bounds.size
//        //        }
//
//        let qrImg = LBXScanWrapper.createCode(codeType: codeType,codeString:生成内容, size: sizex, qrColor: 二维码颜色, bkColor: 背景颜色)
//
//
//        let image1 =  LBXScanWrapper.addImageLogo(srcImg: qrImg!, logoImg: logoImage ?? UIImage(), logoSize:logosize )
//        QRImageView二维码imageView.image = image1
//        QRImageView二维码imageView.bounds = CGRect(x: 0, y: 0, width: InstoryboardBackView.frame.width-12, height: InstoryboardBackView.frame.width-12)
//        QRImageView二维码imageView.center = CGPoint(x: InstoryboardBackView.frame.width/2, y: InstoryboardBackView.frame.height/2)
//
//
//        InstoryboardBackView.addSubview(QRImageView二维码imageView)
//
//    }
//    public func 返回二维码createQR1(rect:CGRect,InstoryboardBackView: UIView,codeType:String = "CIQRCodeGenerator",生成内容:String,大小尺寸CGRect:CGRect? = nil,二维码颜色:UIColor = UIColor.black,背景颜色:UIColor = UIColor.white,logoImage:UIImage? = UIImage() ,logosize:CGSize = CGSize(width: 30, height: 30)) -> UIImageView?{
//
//        let QRImageView二维码imageView = UIImageView()
//        QRImageView二维码imageView.frame = rect
//        let sizex = QRImageView二维码imageView.bounds.size
//        //系统自带能生成的码
//        //        CIAztecCodeGenerator
//        //        CICode128BarcodeGenerator
//        //        CIPDF417BarcodeGenerator
//        //        CIQRCodeGenerator
//
//
//
//        //        var 大小尺寸x = CGSize()
//        //        if let 大小尺寸 = 大小尺寸CGSize{
//        //            大小尺寸x = 大小尺寸
//        //        }
//        //        if let 大小尺寸2 = 大小尺寸CGRect{
//        //            let QRImageView二维码imageView = UIImageView()
//        //            //设定一个大小
//        //
//        //            QRImageView二维码imageView.frame = 大小尺寸2
//        //            大小尺寸x = QRImageView二维码imageView.bounds.size
//        //        }
//
//        let qrImg = LBXScanWrapper.createCode(codeType: codeType,codeString:生成内容, size: sizex, qrColor: 二维码颜色, bkColor: 背景颜色) ?? UIImage()
//
//
//        let image1 =  LBXScanWrapper.addImageLogo(srcImg: qrImg, logoImg: logoImage ?? UIImage(), logoSize:logosize )
//
//        QRImageView二维码imageView.image = image1
//        QRImageView二维码imageView.bounds = CGRect(x: 0, y: 0, width: InstoryboardBackView.frame.width-12, height: InstoryboardBackView.frame.width-12)
//        QRImageView二维码imageView.center = CGPoint(x: InstoryboardBackView.frame.width/2, y: InstoryboardBackView.frame.height/2)
//
//        return QRImageView二维码imageView
//    }
//
//    public func 添加条形码createCode128(生成内容:String,二维码颜色:UIColor = UIColor.black,背景颜色:UIColor = UIColor.white,条形码BackGroundView:UIView){
//
//
//
//
//        let t条形码ImageView = UIImageView()
//        t条形码ImageView.bounds = CGRect(x: 0, y: 0, width: 条形码BackGroundView.frame.width-12, height: 条形码BackGroundView.frame.height-12)
//        t条形码ImageView.center = CGPoint(x: 条形码BackGroundView.frame.width/2, y: 条形码BackGroundView.frame.height/2)
//
//        let qrImg = LBXScanWrapper.createCode128(codeString: 生成内容, size: t条形码ImageView.bounds.size, qrColor: 二维码颜色, bkColor: 背景颜色)
//
//        t条形码ImageView.image = qrImg
//        条形码BackGroundView.addSubview(t条形码ImageView)
//
//    }

//
//    public func 处理阴影纸片效果(Viewx:UIView,frame:CGRect,colorx :UIColor = UIColor.white)  {
//        //        //添加阴影显示
//        Viewx.frame = frame //rect
//        Viewx.backgroundColor = colorx
//        Viewx.layer.shadowOffset = CGSize(width: 0, height: 2)
//        Viewx.layer.shadowRadius = 2
//        Viewx.layer.shadowColor = UIColor.black.cgColor
//        Viewx.layer.shadowOpacity = 0.5
//    }
//
//
//}

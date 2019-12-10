//
//  XYZScanObject.swift
//  TestXYZQRcode
//
//  Created by 张子豪 on 2019/3/18.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit


public var XYZScan = XYZScanObject()

public class XYZScanObject: NSObject {
//    let nav = UINavigationController()
    
    func ImageInBundle(WithName named:String) -> UIImage {
        let bundlePath = Bundle(for: self.classForCoder).bundlePath + "/CodeScan.bundle"
        let bundleXX = Bundle(path: bundlePath)!
        return UIImage(named: named, in: bundleXX, compatibleWith: nil)!
    }

    
    // MARK: - ---模仿qq扫码界面---------
    public func qqStyle(VC:UIViewController,delegate:QQScanViewControllerDelegate) {
        print("qqStyle")
        let vc = QQScanViewController()
        var style = LBXScanViewStyle()
        
        let light_green = ImageInBundle(WithName: "qrcode_scan_light_green@2x")
        style.animationImage = light_green//UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        vc.scanStyle = style
        vc.Resultdelegate = delegate
        VC.present(vc, animated: true, completion: nil)
    }

    
    // MARK: - --模仿支付宝------
    public func ZhiFuBaoStyle(VC:UIViewController) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        
        style.centerUpOffset = 60
        style.xScanRetangleOffset = 30
        
        if UIScreen.main.bounds.size.height <= 480 {
            //3.5inch 显示的扫码缩小
            style.centerUpOffset = 40
            style.xScanRetangleOffset = 20
        }
        
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2.0
        style.photoframeAngleW = 16
        style.photoframeAngleH = 16
        
        style.isNeedShowRetangle = false
        
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_full_net")
        
        let vc = LBXScanViewController()
        
        vc.scanStyle = style
        VC.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    public func createImageWithColor(color: UIColor) -> UIImage {
        let rect=CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
    
    // MARK: - ------条形码扫码界面 ---------
    public func notSquare(VC:UIViewController) {
        //设置扫码区域参数
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 4
        style.photoframeAngleW = 28
        style.photoframeAngleH = 16
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle.LineStill
        style.animationImage = createImageWithColor(color: UIColor.red)
        //非正方形
        //设置矩形宽高比
        style.whRatio = 4.3/2.18
        //离左边和右边距离
        style.xScanRetangleOffset = 30
        let vc = LBXScanViewController()
        vc.scanStyle = style
        VC.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - ---无边框，内嵌4个角 -----
    public func InnerStyle(VC:UIViewController,Delegate:LBXScanViewControllerDelegate) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 3
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        //qq里面的线条图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        let LBXScanvc = LBXScanViewController()
        LBXScanvc.scanStyle = style
        LBXScanvc.scanResultDelegate = Delegate
        VC.navigationController?.pushViewController(LBXScanvc, animated: true)
    }
    
    // MARK: - --无边框，内嵌4个角------
    public func weixinStyle(VC:UIViewController,Delegate:LBXScanViewControllerDelegate) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        let LBXScanvc = LBXScanViewController()
        LBXScanvc.scanStyle = style
        LBXScanvc.scanResultDelegate = Delegate
        VC.navigationController?.pushViewController(LBXScanvc, animated: true)
    }
    
    // MARK: - ---框内区域识别
    public func  recoCropRect(VC:UIViewController) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        style.photoframeLineW = 6
        style.photoframeAngleW = 24
        style.photoframeAngleH = 24
        style.isNeedShowRetangle = true
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid
        //矩形框离左边缘及右边缘的距离
        style.xScanRetangleOffset = 80
        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.isOpenInterestRect = true
        //TODO:待设置框内识别
        VC.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - ----4个角在矩形框线上,网格动画
    public func OnStyle(VC:UIViewController) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        style.photoframeLineW = 6
        style.photoframeAngleW = 24
        style.photoframeAngleH = 24
        style.isNeedShowRetangle = true
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid
        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")
        let vc = LBXScanViewController()
        vc.scanStyle = style
        VC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ------自定义4个角及矩形框颜色
    public func changeColor(VC:UIViewController,Delegate:LBXScanViewControllerDelegate) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        style.photoframeLineW = 6
        style.photoframeAngleW = 24
        style.photoframeAngleH = 24
        style.isNeedShowRetangle = true
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        //4个角的颜色
        style.colorAngle = UIColor(red: 65.0/255.0, green: 174.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        //矩形框颜色
        style.colorRetangleLine = UIColor(red: 247.0/255.0, green: 202.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        //非矩形框区域颜色
        style.color_NotRecoginitonArea = UIColor(red: 247.0/255.0, green: 202.0/255.0, blue: 15.0/255.0, alpha: 0.2)
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.readyString = "相机启动中..."
        VC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - -----改变扫码区域位置
    public func changeSize(VC:UIViewController) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        //矩形框向上移动
        style.centerUpOffset = 60
        //矩形框离左边缘及右边缘的距离
        style.xScanRetangleOffset = 100
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        style.photoframeLineW = 6
        style.photoframeAngleW = 24
        style.photoframeAngleH = 24
        style.isNeedShowRetangle = true
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        //qq里面的线条图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        let vc = LBXScanViewController()
        vc.scanStyle = style
        VC.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - ------- 相册
    public func openLocalPhotoAlbum(VC:UIViewController,delegate:UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        LBXPermissions.authorizePhotoWith { [weak self] (granted) in
            if granted {
                if self != nil {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = delegate
                    picker.allowsEditing = false
                    VC.present(picker, animated: true, completion: nil)
                }
            } else {LBXPermissions.jumpToSystemPrivacySetting()}
        }
    }
}

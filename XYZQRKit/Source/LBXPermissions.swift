//
//  LBXPermissions.swift
//  swiftScan
//
//  Created by xialibing on 15/12/15.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary



public class LBXPermissions: NSObject {

    //MARK: ----获取相册权限
    public static func authorizePhotoWith(comletion:@escaping (Bool)->Void ){
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
            case .authorized:
                comletion(true)
            case .denied,.restricted:
                comletion(false)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    DispatchQueue.main.async {comletion(status == PHAuthorizationStatus.authorized ? true:false)}
                })
            @unknown default:comletion(false)
        }
    }
    
    //MARK: ---相机权限
    public static func authorizeCameraWith(comletion:@escaping (Bool)->Void ){
        let granted = AVCaptureDevice.authorizationStatus(for: .video);
        switch granted {
            case .authorized:comletion(true)
            case .denied:comletion(false)
            case .restricted:comletion(false)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) in
                    DispatchQueue.main.async {comletion(granted)}
                })
            @unknown default:comletion(false)
        }
    }
    
    //MARK:跳转到APP系统设置权限界面
    public static func jumpToSystemPrivacySetting(){
        guard let appSetting = URL(string:UIApplication.openSettingsURLString) else{return}
        UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
    }
}

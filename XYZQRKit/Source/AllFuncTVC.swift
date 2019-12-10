//
//  AllFuncTVC.swift
//  TestXYZQRcode
//
//  Created by 张子豪 on 2018/12/21.
//  Copyright © 2018 张子豪. All rights reserved.
//

import UIKit


class AllFuncTVC: UITableViewController{
    
    var arrayItems = [   "模拟qq扫码界面"   : "qqStyle"       ,
                         "模仿支付宝扫码区域":"ZhiFuBaoStyle"  ,
                         "模仿微信扫码区域"  :"weixinStyle"    ,
                         "无边框，内嵌4个角" :"InnerStyle"     ,
                         "4个角在矩形框线上,网格动画":"OnStyle"  ,
                         "自定义颜色"       : "changeColor"   ,
                         "只识别框内"       :"recoCropRect"   ,
                         "改变尺寸"         :"changeSize"     ,
                         "条形码效果"       :"notSquare"       ,
                         "相册"            :"openLocalPhotoAlbum"
    ]
    
    @IBAction func 关闭BTN(_ sender: Any) {dismiss(animated: true, completion: nil)}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.view.tintColor
    }
}

// MARK: - Table view data source

extension AllFuncTVC{
    // #warning Incomplete implementation, return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {return 1}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return arrayItems.count}
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = Array(arrayItems.keys)[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let KeyX = Array(arrayItems.keys)[indexPath.row]
        switch KeyX {
//        case "模拟qq扫码界面"   :  XYZScan.qqStyle(VC: self, delegate: UIViewController as! QQScanViewControllerDelegate)
            case "模仿支付宝扫码区域":  XYZScan.ZhiFuBaoStyle(VC: self)
            case "模仿微信扫码区域"  :  XYZScan.weixinStyle(VC: self, Delegate: self)
            case "无边框，内嵌4个角" : XYZScan.InnerStyle(VC: self, Delegate: self)
            case "4个角在矩形框线上,网格动画":XYZScan.OnStyle(VC: self)
            case "自定义颜色"      :   XYZScan.changeColor(VC: self, Delegate: self)
            case "只识别框内"      :   XYZScan.recoCropRect(VC: self)
            case "改变尺寸"        :   XYZScan.changeSize(VC: self)
            case "条形码效果"      :   XYZScan.notSquare(VC: self)
            case "相册"           :   XYZScan.openLocalPhotoAlbum(VC: self, delegate: self)
            default:break
        }
    }
}

extension AllFuncTVC: LBXScanViewControllerDelegate {
    //是代理返回的方法
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        print("scanResult:\(scanResult)")
        guard let str = scanResult.strScanned else{return}
        print("显示结果");print(str)
    }
}

import SoHow
extension AllFuncTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - ----相册选择图片识别二维码 （条形码没有找到系统方法）
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {picker.dismiss(animated: true, completion: nil)
        var image:UIImage? = nil
        if image == nil {image = info[.editedImage]   as? UIImage}
        if image == nil {image = info[.originalImage] as? UIImage}
        guard let imagex = image else{showMsg(title: "", message: "识别失败");return}
        let arrayResult = LBXScanWrapper.recognizeQRImage(image: imagex)
        guard arrayResult.count > 0 , let result = arrayResult.first else{showMsg(title: "", message: "识别失败");return}
        showMsg(title: result.strBarCodeType, message: result.strScanned)
    }
}

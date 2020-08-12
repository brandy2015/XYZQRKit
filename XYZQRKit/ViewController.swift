//
//  ViewController.swift
//  XYZQRKit
//
//  Created by 张子豪 on 2019/12/10.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QQScanViewControllerDelegate {
    func Result(_ controller: QQScanViewController, didFinishGet ScanResults: [LBXScanResult]) {
         
    }
    
    func Result(_ controller: QQScanViewController) {
         
    }
    

    @IBAction func sdfas(_ sender: Any) {
        
         XYZScan.qqStyle(VC: self, delegate: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


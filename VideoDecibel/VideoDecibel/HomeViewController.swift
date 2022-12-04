//
//  HomeViewController.swift
//  VideoDecibel
//
//  Created by 박수성 on 2022/12/04.
//

import UIKit
import AVFoundation
import Photos
import PssCore

class HomeViewController: UIViewController {
    private let alertViewController = AlertViewController(nibName: "AlertViewController", bundle: Bundle(identifier: "kr.co.ipdisk.dbspark711.PssCore")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(alertViewController.view)
        alertViewController.hide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PHPhotoLibrary.requestAuthorization { status in
            
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            
        }
    }
    
    @IBAction func onClickVideoDecibel(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                    if granted {
                        
                    } else {
                        DispatchQueue.main.async {
                            self?.alertViewController.show_typeOK(withMsg: "임시1") {
                                
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.alertViewController.show_typeOK(withMsg: "임시2") {
                        
                    }
                }
            }
        }
    }
}

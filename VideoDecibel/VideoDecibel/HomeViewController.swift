//
//  HomeViewController.swift
//  VideoDecibel
//
//  Created by 박수성 on 2022/12/04.
//

import UIKit
import AVFoundation
import Photos

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    if granted {
                        
                    } else {
                        
                    }
                }
            } else {
                
            }
        }
    }
}

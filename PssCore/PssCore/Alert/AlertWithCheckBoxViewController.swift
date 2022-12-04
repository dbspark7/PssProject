//
//  MyAlertWithCheckBoxViewController.swift
//  EveryXCam
//
//  Created by iot-parksooseong on 2021/08/09.
//  Copyright © 2021 Truen. All rights reserved.
//

import UIKit
import M13Checkbox

@objc class SwiftAlertWithCheckBoxViewController: UIViewController {
    @IBOutlet var lblNotice: UILabel!
    
    @IBOutlet var vCheckBox: UIView!
    @IBOutlet var lblCheckBox: UILabel!
    @IBOutlet var btnCheckBox: UIButton!
    private let chkBtn = M13Checkbox()
    
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var btnRight: UIButton!
    @IBOutlet var btnOK: UIButton!
    
    private var okHandler: ResponseBlock?
    private var lHandler: ResponseBlock?
    private var rHandler: ResponseBlock?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DLog("[SwiftAlertWithCheckBoxViewController][LifeCycle] viewDidLoad")
        
        lblNotice.lineBreakMode = .byCharWrapping
        vCheckBox.addSubview(chkBtn)
        chkBtn.stateChangeAnimation = .fill
        chkBtn.boxType = .square
        chkBtn.markType = .checkmark
        chkBtn.checkmarkLineWidth = 2
        chkBtn.boxLineWidth = 2
        chkBtn.tintColor = MyColor.flutterPrimary()
        chkBtn.animationDuration = 0.0
        chkBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        btnLeft.setTitleColor(MyColor.flutterPrimary(), for: .normal)
        btnRight.setTitleColor(MyColor.flutterPrimary(), for: .normal)
        btnOK.setTitleColor(MyColor.flutterPrimary(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DLog("[SwiftAlertWithCheckBoxViewController][LifeCycle] viewWillAppear")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.frame = UIScreen.main.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DLog("[SwiftAlertWithCheckBoxViewController][LifeCycle] viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DLog("[SwiftAlertWithCheckBoxViewController][LifeCycle] viewDidDisappear")
    }
    
    deinit {
        DLog("[SwiftAlertWithCheckBoxViewController][LifeCycle] deinit")
    }
    
    @objc func show_typeYesOrNo(withMsg msg: String, checkboxMsg: String, bCheck: Bool, noHandler: @escaping ResponseBlock, yesHandler: @escaping ResponseBlock) {
        lHandler = noHandler
        rHandler = yesHandler
        
        lblNotice.text = msg
        
        btnLeft.isHidden = false
        btnRight.isHidden = false
        btnOK.isHidden = true
        
        btnCheckBox.isSelected = bCheck
        if bCheck {
            chkBtn.checkState = .checked
        } else {
            chkBtn.checkState = .unchecked
        }
        lblCheckBox.text = checkboxMsg
        
        btnLeft.setTitle(NSLocalizedString("button_no", comment: ""), for: .normal)
        btnRight.setTitle(NSLocalizedString("button_yes", comment: ""), for: .normal)
        
        showWithAnimation(self.view)
    }
    
    @objc func show_typeOK(withMsg msg: String, checkboxMsg: String, okHandler: @escaping ResponseBlock) {
        self.okHandler = okHandler
        
        lblNotice.text = msg
        
        btnLeft.isHidden = true
        btnRight.isHidden = true
        btnOK.isHidden = false
        
        btnCheckBox.isSelected = false
        chkBtn.checkState = .unchecked
        lblCheckBox.text = checkboxMsg
        
        showWithAnimation(self.view)
    }
    
//    @objc func show_typeCancelOrOK(withMsg msg: String, cancelHandler: @escaping ResponseBlock, okHandler: @escaping ResponseBlock) {
//
//    }
//
//    @objc func show_2Button(withMsg msg: String, leftButtonText: String, rightButtonText: String, leftHandler: @escaping ResponseBlock, rightHandler: @escaping ResponseBlock) {
//
//    }
//
//    @objc func show_typeAgree(withMsg msg: String, checkboxMsg: String, leftButtonText: String, rightButtonText: String, noHandler: @escaping ResponseBlock, yesHandler: @escaping ResponseBlock) {
//
//    }
    
    @objc func hide() {
        self.view.isHidden = true
    }
    
    @IBAction func onClickCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            chkBtn.checkState = .checked
        } else {
            chkBtn.checkState = .unchecked
        }
    }
    
    @IBAction func onClickLeft(_ sender: UIButton) {
        hideWithAnimation(self.view)
        lHandler?()
    }
    
    @IBAction func onClickRight(_ sender: UIButton) {
        hideWithAnimation(self.view)
        rHandler?()
    }
    
    @IBAction func onClickOK(_ sender: UIButton) {
        hideWithAnimation(self.view)
        okHandler?()
    }
}

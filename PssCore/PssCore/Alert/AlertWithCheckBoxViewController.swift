//
//  AlertWithCheckBoxViewController.swift
//  PssCore
//
//  Created by 박수성 on 2022/12/04.
//

import UIKit
import SnapKit
import M13Checkbox

public class AlertWithCheckBoxViewController: UIViewController {
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
    
    override public var prefersStatusBarHidden: Bool {
        return false
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override public var shouldAutorotate: Bool {
        return true
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        DLog("viewDidLoad")
        
        lblNotice.lineBreakMode = .byCharWrapping
        vCheckBox.addSubview(chkBtn)
        chkBtn.stateChangeAnimation = .fill
        chkBtn.boxType = .square
        chkBtn.markType = .checkmark
        chkBtn.checkmarkLineWidth = 2
        chkBtn.boxLineWidth = 2
        chkBtn.tintColor = tintColor
        chkBtn.animationDuration = 0.0
        chkBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        btnLeft.setTitleColor(tintColor, for: .normal)
        btnRight.setTitleColor(tintColor, for: .normal)
        btnOK.setTitleColor(tintColor, for: .normal)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DLog("viewWillAppear")
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.frame = UIScreen.main.bounds
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DLog("viewWillDisappear")
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DLog("viewDidDisappear")
    }
    
    deinit {
        DLog("deinit")
    }
    
    public func show_typeYesOrNo(withMsg msg: String, checkboxMsg: String, bCheck: Bool, noHandler: @escaping ResponseBlock, yesHandler: @escaping ResponseBlock) {
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
    
    public func show_typeOK(withMsg msg: String, checkboxMsg: String, okHandler: @escaping ResponseBlock) {
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
    
    public func hide() {
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

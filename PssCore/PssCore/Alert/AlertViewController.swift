//
//  AlertViewController.swift
//  PssCore
//
//  Created by 박수성 on 2022/12/04.
//

import UIKit

public class AlertViewController: UIViewController {
    @IBOutlet var lblNotice: UILabel!
    
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var vSeparate: UIView!
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
        
        btnLeft.setTitle(NSLocalizedString("button_no", comment: ""), for: .normal)
        btnRight.setTitle(NSLocalizedString("button_yes", comment: ""), for: .normal)
        btnOK.setTitle(NSLocalizedString("button_ok", comment: ""), for: .normal)
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
    
    public func show_typeYesOrNo(withMsg msg: String, noHandler: @escaping ResponseBlock, yesHandler: @escaping ResponseBlock) {
        lHandler = noHandler
        rHandler = yesHandler
        
        lblNotice.text = msg
        
        btnLeft.isHidden = false
        vSeparate.isHidden = false
        btnRight.isHidden = false
        btnOK.isHidden = true
        
        showWithAnimation(self.view)
    }
    
//    func show_2Button(withMsg msg: String, leftButtonText: String, rightButtonText: String, leftHandler: @escaping ResponseBlock, rightHandler: @escaping ResponseBlock) {
//        lHandler = leftHandler
//        rHandler = rightHandler
//
//        lblNotice.text = msg
//
//        btnLeft.setTitle(leftButtonText, for: .normal)
//        btnRight.setTitle(rightButtonText, for: .normal)
//
//        btnLeft.isHidden = false
//        vSeparate.isHidden = false
//        btnRight.isHidden = false
//        btnOK.isHidden = true
//
//        self.view.isHidden = false
//    }
    
    public func show_typeOK(withMsg msg: String, okHandler: @escaping ResponseBlock) {
        self.okHandler = okHandler
        
        lblNotice.text = msg
        
        btnLeft.isHidden = true
        vSeparate.isHidden = true
        btnRight.isHidden = true
        btnOK.isHidden = false
        
        showWithAnimation(self.view)
    }
    
    public func hide() {
        hideWithAnimation(self.view)
    }
    
    @IBAction func onClickLeft(_ sender: UIButton) {
        lHandler?()
        hideWithAnimation(self.view)
    }
    
    @IBAction func onClickRight(_ sender: UIButton) {
        rHandler?()
        hideWithAnimation(self.view)
    }
    
    @IBAction func onClickOK(_ sender: UIButton) {
        okHandler?()
        hideWithAnimation(self.view)
    }
}

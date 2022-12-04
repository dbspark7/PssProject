//
//  CoreExtension.swift
//  PssCore
//
//  Created by 박수성 on 2022/12/04.
//

import UIKit

public extension UIViewController {
    func showWithAnimation(_ view: UIView, _ completion: (() -> Void)? = nil) {
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        view.isHidden = false
        
        UIView.animate(withDuration: 0.1) {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } completion: { finished in
            view.setNeedsUpdateConstraints()
            completion?()
        }
    }
    
    func hideWithAnimation(_ view: UIView) {
        view.isHidden = true
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
}

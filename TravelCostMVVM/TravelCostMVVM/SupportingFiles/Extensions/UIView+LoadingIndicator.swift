//
//  UIView+LoadingIndicator.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit

extension UIView {
    public func showLoading() {
        let indicator = UIActivityIndicatorView(frame: self.frame)
        let transparentView = UIImageView()
        transparentView.tag = 144
        indicator.tag = 244
        transparentView.frame = self.bounds
        transparentView.backgroundColor = UIColor.black
        transparentView.isUserInteractionEnabled = true
        transparentView.alpha = 0.5
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = transparentView.center
        indicator.startAnimating()
        indicator.color = .systemTeal
        DispatchQueue.main.async {
            self.addSubview(transparentView)
            self.addSubview(indicator)
            self.bringSubviewToFront(transparentView)
            self.bringSubviewToFront(indicator)
        }
    }
    public func hideLoading() {
        DispatchQueue.main.async { [self] in
            viewWithTag(144)?.removeFromSuperview()
            viewWithTag(244)?.removeFromSuperview()
        }
    }
}

//
//  BaseViewController.swift
//  Near Me
//
//  Created by Mohammed Salah on 15/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class BaseViewController: UIViewController {
    var activityIndicatorView: NVActivityIndicatorView?
    var viewLoadingContainer: UIView?

    func showDefaultLoader(backgroundColor: UIColor = UIColor.darkGray.withAlphaComponent(0.5)) {
        let barHeight = (navigationController?.navigationBar.frame.height ?? 44) + UIApplication.shared.statusBarFrame.height
        if activityIndicatorView == nil {
            activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: .blue, padding: 0)
        }

        var center = CGPoint()
        if let frame = navigationController?.view.bounds {
            viewLoadingContainer = UIView(frame: frame)
            viewLoadingContainer?.frame.origin.y = barHeight
            center = (navigationController?.view.center)!
        } else if let windowFrame = UIApplication.shared.keyWindow?.frame {
            viewLoadingContainer = UIView(frame: windowFrame)
            center = UIApplication.shared.keyWindow!.center
            viewLoadingContainer?.frame.origin.y = barHeight
        }
        center.y -= barHeight
        activityIndicatorView?.center = center
        viewLoadingContainer?.backgroundColor = backgroundColor
        activityIndicatorView?.startAnimating()
        viewLoadingContainer?.addSubview(activityIndicatorView!)

        view.addSubview(viewLoadingContainer!)
    }

    func hideDefaultLoader() {
        if let activity = activityIndicatorView {
            activity.removeFromSuperview()
            activity.stopAnimating()
        }

        if let loadingContainer = viewLoadingContainer {
            loadingContainer.removeFromSuperview()
        }
    }
}

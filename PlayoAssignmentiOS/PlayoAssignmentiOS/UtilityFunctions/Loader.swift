//
//  Loader.swift
//  Rendezvous
//
//  Created by iPHTech 33 on 14/03/19.
//  Copyright © 2019 iPHTech 33. All rights reserved.
//

import Foundation
import UIKit

var timerForLoader: Timer?

extension UIViewController{

    func showLoader(msg:String = "", animationType: NVActivityIndicatorType = .circleStrokeSpin, color: UIColor = primaryGreenColor, timeInterval: TimeInterval = 30.0, size: CGSize = CGSize(width: 70, height: 70)){
        let activityData =  ActivityData(size: size, message: msg, messageFont: nil, messageSpacing: nil, type: animationType, color: color, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: UIColor.clear, textColor: UIColor.white)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        timerForLoader?.invalidate()
        timerForLoader = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.hideLoaderAfterWaitingTime), userInfo: nil, repeats: false)
    }

    @objc func hideLoaderAfterWaitingTime() {
        
        if NVActivityIndicatorPresenter.sharedInstance.isAnimating {
            hideLoader()
        }
    }
    
    func hideLoader() {
        timerForLoader?.invalidate()
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }

}

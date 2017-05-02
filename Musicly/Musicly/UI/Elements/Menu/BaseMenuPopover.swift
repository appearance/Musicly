//
//  BaseMenuPopover.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class BasePopoverMenu: UIView {
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.opacity = 0.2
        return containerView
    }()
    
    func showPopView(viewController: UIViewController) {
        //containerView.frame = UIScreen.main.bounds
        //containerView.center = CGPoint(x: BasePopoverAlertConstants.popViewX, y: BasePopoverAlertConstants.popViewY)
        viewController.view.addSubview(containerView)
    }
    
    func hidePopView(viewController:UIViewController){
        viewController.view.sendSubview(toBack: containerView)
    }
}
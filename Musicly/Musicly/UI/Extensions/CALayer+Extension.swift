//
//  CALayer+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension CALayer {
    
    // TODO: - This can be implemented better
    
    func setCellShadow(contentView: UIView) {
        let shadowOffsetWidth: CGFloat = contentView.bounds.height * CALayerConstants.shadowWidthMultiplier
        let shadowOffsetHeight: CGFloat = contentView.bounds.width * CALayerConstants.shadowHeightMultiplier
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        shadowRadius = 1.5
        shadowOpacity = 0.5
    }
    
    func setViewShadow(view: UIView) {
        print(view)
        let shadowOffsetWidth: CGFloat = view.bounds.height * CALayerConstants.shadowWidthMultiplier
        let shadowOffsetHeight: CGFloat = view.bounds.width * CALayerConstants.shadowHeightMultiplier
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: shadowOffsetWidth + 2, height: shadowOffsetHeight)
        shadowRadius = 5
        shadowOpacity = 0.7
    }
}

//
//  UICollectionView+Extension.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func getHeader(indexPath: IndexPath, identifier: String) -> HeaderReusableView {
        let reusableView = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                 withReuseIdentifier: identifier,
                                                                 for: indexPath) as! HeaderReusableView
        return reusableView
    }
}

extension UICollectionView {
    func updateLayout(newLayout: UICollectionViewLayout) {
        DispatchQueue.main.async {
            self.reloadData()
            self.setCollectionViewLayout(newLayout, animated: true)
        }
    }
}

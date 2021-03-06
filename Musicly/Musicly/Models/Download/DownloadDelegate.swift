//
//  DownloadDelegate.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/3/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol DownloadDelegate: class {
    func downloadProgressUpdated(for progress: Float)
}

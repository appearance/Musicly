//
//  OpenPlayerProtocol.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol OpenPlayerProtocol {
    func setup(playlist: Playlist, index: Int) -> PlayerViewController
}

extension OpenPlayerProtocol {
    func setup(playlist: Playlist, index: Int) -> PlayerViewController {
        let destination = PlayerViewController()
        destination.hidesBottomBarWhenPushed = true
        var model = PlayerControllerModel(index: index)
        model.playlist = playlist
        destination.model = model 
        return destination
    }
}

//
//  PlayerView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol PlayerViewDelegate: class {
    func downloadButtonTapped()
    func playButtonTapped()
    func pauseButtonTapped()
}

class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?
    
    var track: iTrack?
    
    var albumArtworkView: UIImageView = {
        var albumArtworkView = UIImageView()
        albumArtworkView.backgroundColor = .white
        return albumArtworkView
    }()
    
    var artworkView: UIView = {
        var artworkView = UIView()
        artworkView.backgroundColor = UIColor(red:0.86, green:0.87, blue:0.90, alpha:1.0)
        return artworkView
    }()
    
    var trackTitleView: UIView = {
        let trackTitleView = UIView()
        trackTitleView.backgroundColor = .white
        return trackTitleView
    }()
    
    var controlsView: UIView = {
        let controlsView = UIView()
        controlsView.backgroundColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        return controlsView
    }()
    
    var preferencesView: UIView = {
        let preferencesView = UIView()
        preferencesView.backgroundColor = .white
        return preferencesView
    }()
    
    var trackTitleLabel: UILabel = {
        var trackTitleLabel = UILabel()
        trackTitleLabel.textColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        trackTitleLabel.textAlignment = .center
        return trackTitleLabel
    }()
    
    fileprivate var downloadButton: UIButton = {
        var downloadButton = UIButton()
        downloadButton.setImage(#imageLiteral(resourceName: "download200x"), for: .normal)
        return downloadButton
    }()
    
    fileprivate var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "whitetriangleplay"), for: .normal)
        return playButton
    }()
    
    fileprivate var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "pausebutton-2white"), for: .normal)
        return pauseButton
    }()
    
    override func layoutSubviews() {
        backgroundColor = UIColor(red:0.86, green:0.87, blue:0.90, alpha:1.0)
        setupView()
        pauseButton.alpha = 0
    }
    
    func configure(with track: iTrack) {
        self.track = track
        if let url = URL(string: track.artworkUrl) {
            albumArtworkView.downloadImage(url: url)
            trackTitleLabel.text = track.trackName
        }
        albumArtworkView.layer.setCellShadow(contentView: albumArtworkView)
        trackTitleView.layer.setCellShadow(contentView: trackTitleView)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    func setupView() {
        
        addSubview(trackTitleView)
        trackTitleView.translatesAutoresizingMaskIntoConstraints = false
        trackTitleView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        trackTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
        trackTitleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(artworkView)
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        artworkView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        artworkView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        artworkView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        artworkView.topAnchor.constraint(equalTo: trackTitleView.bottomAnchor).isActive = true
        
        artworkView.addSubview(albumArtworkView)
        albumArtworkView.translatesAutoresizingMaskIntoConstraints = false
        albumArtworkView.widthAnchor.constraint(equalTo: artworkView.widthAnchor, multiplier: 0.7).isActive = true
        albumArtworkView.heightAnchor.constraint(equalTo: artworkView.heightAnchor, multiplier: 0.75).isActive = true
        albumArtworkView.centerXAnchor.constraint(equalTo: artworkView.centerXAnchor).isActive = true
        albumArtworkView.centerYAnchor.constraint(equalTo: artworkView.centerYAnchor).isActive = true
        
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06).isActive = true
        preferencesView.topAnchor.constraint(equalTo: artworkView.bottomAnchor).isActive = true
        
        addSubview(controlsView)
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        controlsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        controlsView.topAnchor.constraint(equalTo: preferencesView.bottomAnchor).isActive = true
        
        trackTitleView.addSubview(trackTitleLabel)
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleLabel.widthAnchor.constraint(equalTo: trackTitleView.widthAnchor, multiplier: 1).isActive = true
        trackTitleLabel.heightAnchor.constraint(equalTo: trackTitleView.heightAnchor, multiplier: 1).isActive = true
        trackTitleLabel.centerYAnchor.constraint(equalTo: trackTitleView.centerYAnchor, constant: controlsView.bounds.height * 0.5).isActive = true
        
        controlsView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.12).isActive = true
        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.2).isActive = true
        playButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor).isActive = true
        
        controlsView.addSubview(pauseButton)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.12).isActive = true
        pauseButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.2).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor).isActive = true
    }
    
    func downloadButtonTapped() {
        delegate?.downloadButtonTapped()
    }
    
    func playButtonTapped() {
        delegate?.playButtonTapped()
        playButton.isEnabled = false
        playButton.alpha = 0
        pauseButton.isEnabled = true
        pauseButton.alpha = 1
        controlsView.bringSubview(toFront: pauseButton)
        controlsView.sendSubview(toBack: playButton)
    }
    
    func pauseButtonTapped() {
        delegate?.pauseButtonTapped()
        controlsView.bringSubview(toFront: playButton)
        controlsView.sendSubview(toBack: pauseButton)
        playButton.isEnabled = true
        playButton.alpha = 1
        pauseButton.isEnabled = false
        pauseButton.alpha = 0
    }
}

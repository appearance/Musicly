//
//  PlaylistCell.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/22/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PlaylistCell: UICollectionViewCell {
    
    private var playlistArtView: UIImageView = {
        var playlistArtView = UIImageView()
        playlistArtView.layer.borderColor = UIColor.black.cgColor
        playlistArtView.layer.borderWidth = 1.5
        return playlistArtView
    }()
    
    private var listTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Medium", size: 14)!
        return label
    }()
    
    private var cellImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "cellbutton")
        return image
    }()
    
    private var playlistNameLabel: UILabel = {
        var playlistNameLabel = UILabel()
        playlistNameLabel.textAlignment = .left
        playlistNameLabel.font = UIFont(name: "Avenir-Medium", size: 22)!
        return playlistNameLabel
    }()
    
    private var numberOfSongsLabel: UILabel = {
        let numberOfSongs = UILabel()
        numberOfSongs.text = "10"
        numberOfSongs.textAlignment = .left
        numberOfSongs.font =  UIFont(name: "Avenir-Light", size: 14)!
        return numberOfSongs
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = .white
        setupPlaylistCellContentViewLayerStyle(for: contentView)
        layer.setupPlaylistCellShadow(bounds: bounds, cornerRadius: contentView.layer.cornerRadius)
        DispatchQueue.main.async {
            self.playlistArtView.setRounded(frame: self.playlistArtView.frame)
        }
    }
    
    func configure(playlistName: String, artUrl: URL?, numberOfTracks: String) {
        setupConstraints()
        if let artUrl = artUrl {
            playlistArtView.downloadImage(url: artUrl)
        } else {
            playlistArtView.image = #imageLiteral(resourceName: "blue-record")
        }
        listTypeLabel.text = "Playlist"
        playlistNameLabel.text = "\(playlistName)"
        
        guard let numberOfTracks = Int(numberOfTracks) else { return }
        
        if numberOfTracks < 1 {
            numberOfSongsLabel.text = "No Tracks"
        } else if numberOfTracks < 2 {
            numberOfSongsLabel.text = "\(numberOfTracks) Track"
        } else {
            numberOfSongsLabel.text = "\(numberOfTracks) Tracks"
        }
        layoutSubviews()
    }
    
    private func sharedLayoutProperties(view: UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.06).isActive = true
    }
    
    private func setupCellImage(image: UIImageView) {
        contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true 
        cellImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        cellImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.101).isActive = true
        cellImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.06).isActive = true
    }
    
    private func setupArtView(playlistArtView: UIImageView) {
        contentView.addSubview(playlistArtView)
        playlistArtView.translatesAutoresizingMaskIntoConstraints = false
        playlistArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.06).isActive = true
        playlistArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playlistArtView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.255).isActive = true
        playlistArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65).isActive = true
    }
    
    private func setupConstraints() {
        sharedLayoutProperties(view: playlistNameLabel)
        playlistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.16).isActive = true
        
        sharedLayoutProperties(view: numberOfSongsLabel)
        numberOfSongsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.2).isActive = true
        
        sharedLayoutProperties(view: listTypeLabel)
        listTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.06).isActive = true
        
        setupCellImage(image: cellImage)
        setupArtView(playlistArtView: playlistArtView)
    }
}

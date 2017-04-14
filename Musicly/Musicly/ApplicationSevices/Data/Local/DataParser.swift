//
//  DataParser.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

final class DataParser {
    
    // TODO: - Figure out if this is necessary
    
    static func parseDataForTrack(json: JSON) -> iTrack?{
        if let track = iTrack(json: json) {
            return track
        }
        return nil
    }
    
    static func parseDataForTracks(json: JSON) -> [iTrack]? {
        var tracks = [iTrack]()
        if let tracksJSON = json["results"] as? [[String : Any]] {
            for trackJSON in tracksJSON {
                if let track = parseDataForTrack(json: trackJSON) {
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
}

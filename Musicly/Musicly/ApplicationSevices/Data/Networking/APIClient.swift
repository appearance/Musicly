//
//  APIClient.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

@objc(iTunesAPIClient)
final class iTunesAPIClient: NSObject {
    
    var tracks: [iTrack]?
    var activeDownloads: [String: Download]?
    var defaultSession: URLSession? = URLSession(configuration: .default)
    
    var downloadsSession : URLSession {
        get {
            let config = URLSessionConfiguration.background(withIdentifier: "background")
            return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        }
    }
    
    override init() {
        super.init()
    }
    
    func setup() {
        activeDownloads = [String: Download]()
        tracks = [iTrack]()
    }
    
    static func search(for query: String, completion: @escaping (_ responseObject: JSON?, _ error: Error?) -> Void) {
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string:"https://itunes.apple.com/search?media=music&entity=song&term=\(encodedQuery)") {
            self.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    if let data = data,
                        let responseObject = self.convertToJSON(with: data) {
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    } else {
                        completion(nil, NSError.generalParsingError(domain: url.absoluteString))
                    }
                }
            }
        }
    }
    
    static func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    fileprivate static func convertToJSON(with data: Data) -> JSON? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
        } catch {
            return nil
        }
    }
    
}

extension iTunesAPIClient: URLSessionDownloadDelegate {
    
    func downloadTrackPreview(for download: Download?) {
        if let download = download,
            let urlString = download.url,
            let url = URL(string: urlString) {
            download.isDownloading = true
            download.downloadStatus = .downloading
            activeDownloads?[urlString] = download
            download.downloadTask = downloadsSession.downloadTask(with: url)
            download.downloadTask?.resume()
        }
    }
    
    func startDownload(_ download: Download?) {
        if let download = download, let url = download.url {
            activeDownloads?[url] = download
            if let url = download.url {
                if URL(string: url) != nil {
                    downloadTrackPreview(for: download)
                }
            }
        }
        
        func trackIndexForDownloadTask(_ downloadTask: URLSessionDownloadTask) -> Int? {
            if let url = downloadTask.originalRequest?.url?.absoluteString,
                let tracks = tracks {
                for (index, track) in tracks.enumerated() {
                    if url == track.previewUrl {
                        return index
                    }
                }
            }
            return nil
        }
    }
    
}

// MARK: - URLSessionDelegate

extension iTunesAPIClient: URLSessionDelegate {
    
    internal func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads?[downloadUrl] {
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        }
    }
}

extension iTunesAPIClient {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString {
            let destinationURL = LocalStorageManager.localFilePathForUrl(originalURL)
            let fileManager = FileManager.default
            
            do {
                try fileManager.removeItem(at: destinationURL!)
            } catch {
                print("Non fatal error, \(error.localizedDescription)")
            }
            
            do {
                try fileManager.copyItem(at: location, to: destinationURL!)
            } catch let error {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads?[downloadUrl] {
            download.downloadStatus = .finished
            download.isDownloading = false
        }
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: URLSession) {
        print("\(session)")
    }
}

extension NSError {
    static func generalParsingError(domain: String) -> Error {
        return NSError(domain: domain, code: 400, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Error retrieving data", comment: "General Parsing Error Description")])
    }
}
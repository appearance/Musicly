import UIKit

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

final class iTunesAPIClient: NSObject {
    
    var activeDownloads: [String: Download]? = [String: Download]()
    
    weak var downloadsSession : URLSession? {
        get {
            let config = URLSessionConfiguration.background(withIdentifier: "background")
            weak var queue = OperationQueue()
            return URLSession(configuration: config, delegate: self, delegateQueue: queue)
        }
    }
    
    // MARK: - Main search functionality
    
    static func search(for query: String, completion: @escaping (Response) -> Void) {
        let urlConstructor = URLConstructor(searchTerm: query)
        guard let url = urlConstructor.build(searchTerm: urlConstructor.searchTerm) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    DispatchQueue.main.async {
                        completion(.success(responseObject!))
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
}

extension iTunesAPIClient: URLSessionDelegate {
    
    func downloadTrackPreview(for download: Download?) {
        if let download = download,
            let urlString = download.url,
            let url = URL(string: urlString) {
            activeDownloads?[urlString] = download
            download.downloadTask = downloadsSession?.downloadTask(with: url)
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
    }
    
    internal func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads?[downloadUrl] {
            download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
}

extension iTunesAPIClient: URLSessionDownloadDelegate {

    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString {
            let destinationURL = LocalStorageManager.localFilePathForUrl(originalURL)
            let fileManager = FileManager.default
            
            do {
                if let destinationURL = destinationURL {
                    try fileManager.copyItem(at: location, to: destinationURL)
                }
            } catch let error {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
    }
    
}

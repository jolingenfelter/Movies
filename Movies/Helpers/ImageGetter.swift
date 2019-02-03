//
//  ImageGetter.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/3/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import Foundation
import UIKit

class ImageGetter {
    
    static public var sharedInstance = ImageGetter()
    
    enum ImageGetterError: Error {
        case unknown
    }
    
    typealias CompletionHandler = (Result<UIImage>) -> Void
    
    private struct Task {
        let sessionTask: URLSessionTask
        let listeners: [CompletionHandler]
        let diskCachePath: String
        let inMemoryCacheName: NSString
    }
    
    private let imageGetterQueue = DispatchQueue(label: "com.ImageGetter.imageGetterQueue")
    private let session = URLSession(configuration: .default)
    private var tasks: [URL: Task] = [:]
    private let cache = NSCache<NSString, UIImage>()
    private static var cacheDirectory: String {
        return (NSTemporaryDirectory() as NSString).appendingPathComponent("\(String(describing: ImageGetter.self))/")
    }
    
    private init() {
        createCacheDirectory()
    }
    
    private func createCacheDirectory() {
        do {
            try FileManager.default.createDirectory(atPath: ImageGetter.cacheDirectory, withIntermediateDirectories: true, attributes: [:])
        } catch {
            fatalError("Failed to create storage cache directory")
        }
    }
    
    func getImage(from url: URL, completion: @escaping CompletionHandler) {
        imageGetterQueue.async { [weak self] in
            self?._getImage(from: url, completion: completion)
        }
    }
    
    private func _getImage(from url: URL, completion: @escaping CompletionHandler) {
        let urlString = url.absoluteString
        let cacheFileName = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? String(urlString.hash)
        let diskCachePath = (ImageGetter.cacheDirectory as NSString).appendingPathComponent(cacheFileName)
        let inMemoryCacheName = cacheFileName as NSString
        
        if let cachedImage = cache.object(forKey: inMemoryCacheName) {
            completion(.success(cachedImage))
        } else if let image = UIImage(contentsOfFile: diskCachePath) {
            cache.setObject(image, forKey: inMemoryCacheName)
            completion(.success(image))
        } else if let existingTask = tasks[url] {
            let newTask = Task(sessionTask: existingTask.sessionTask,
                               listeners: existingTask.listeners + [completion],
                               diskCachePath: diskCachePath,
                               inMemoryCacheName: inMemoryCacheName)
            tasks[url] = newTask
        } else {
            let sessionTask = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                    
                }
        
                strongSelf.handleSessionTaskCompletion(url: url, data: data, response: response, error: error)
            })
           
            tasks[url] = Task(sessionTask: sessionTask,
                              listeners: [completion],
                              diskCachePath: diskCachePath,
                              inMemoryCacheName: inMemoryCacheName)
         
            sessionTask.resume()
        }
    }
    
    private func handleSessionTaskCompletion(url: URL, data: Data?, response: URLResponse?, error: Error?) {
        imageGetterQueue.async { [weak self] in
            guard let strongSelf = self,
                let task = strongSelf.tasks[url] else {
                    return
            }
            
            strongSelf.tasks[url] = nil
            
            let result: Result<UIImage>
            if let error = error {
                result = .failure(error)
            } else if let data = data,
                let image = UIImage(data: data) {
                strongSelf.cache.setObject(image, forKey: task.inMemoryCacheName)
                try? image.jpegData(compressionQuality: 1.0)?.write(to: URL(fileURLWithPath: task.diskCachePath), options: [])
                result = .success(image)
            } else {
                result = .failure(ImageGetterError.unknown)
            }
            
            task.listeners.forEach { $0(result) }
        }
    }
    
}

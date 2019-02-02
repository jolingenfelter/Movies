//
//  APIClient.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

public let JLNetworkingErrorDomain = "com.jolingenfelter.Movies.NetworkingError"
public let missingHTTPResponseError: Int = 10
public let unhandledResponse = 30
public let abnormalError: Int = 40

typealias SuccessHandler = (Data) -> ()
typealias FailureHandler = (Error) -> ()

protocol APIClient {
    var session: URLSession { get }
}

extension APIClient {
    func fetchData(withRequest request: URLRequest, successHandler: SuccessHandler?, failureHandler: FailureHandler?) {
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.global(qos: .utility).async {
                let task = self.session.dataTask(with: request) { (data, response, error) in
                    guard let HTTPURLResponse = response as? HTTPURLResponse else {
                        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("MissingHTTPResponse", comment: "")]
                        let error = NSError(domain: JLNetworkingErrorDomain, code: missingHTTPResponseError, userInfo: userInfo)
                        DispatchQueue.main.async {
                            failureHandler?(error)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            switch HTTPURLResponse.statusCode {
                            case 200:
                                successHandler?(data)
                            default:
                                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Received HTTPURLREsponse: \(HTTPURLResponse.statusCode)", comment: "")]
                                let error = NSError(domain: JLNetworkingErrorDomain, code: unhandledResponse, userInfo: userInfo)
                                failureHandler?(error)
                            }
                        } else {
                            if let error = error {
                                failureHandler?(error)
                            } else {
                                let userInfo = [NSLocalizedDescriptionKey: "An abnormal error occured"]
                                let error = NSError(domain: JLNetworkingErrorDomain, code: abnormalError, userInfo: userInfo)
                                failureHandler?(error)
                            }
                        }
                    }
                    
                }
                task.resume()
            }
        }
    }
}

//
//  URLSession+Extension.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

extension URLSession: SessionRequest {
    func dataTask(with request: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

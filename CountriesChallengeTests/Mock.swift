//
//  Mock.swift
//  CountriesChallengeTests
//
//  Created by Leo Li on 5/8/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var mockedData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request // Return the original request
    }

    override func startLoading() {
        
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,  // No Content
            httpVersion: "HTTP/1.1",
            headerFields: nil
        )!
        
        if let data = MockURLProtocol.mockedData {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let resData = MockURLProtocol.mockedData {
                self.client?.urlProtocol(self, didLoad: resData)
            }
        }
        // Once done, inform that loading is complete
        self.client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}


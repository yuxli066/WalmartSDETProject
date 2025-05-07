//
//  CountriesServiceTests.swift
//  CountriesChallengeTests
//
//  Created by Leo Li on 5/7/25.
//

@testable import CountriesChallenge
import XCTest
import Foundation

/**
    we add the below to override CountriesServiceError's equatability
 */
extension CountriesServiceError: @retroactive Equatable {
    static public func == (lhs: CountriesServiceError, rhs: CountriesServiceError) -> Bool {
        switch (lhs, rhs) {
            case (.invalidUrl(let lhsUrl), .invalidUrl(let rhsUrl)):
                return lhsUrl == rhsUrl
            case (.invalidData, .invalidData),
                 (.decodingFailure, .decodingFailure):
                return true
            case (.failure(let lhsError), .failure(let rhsError)):
                // Check if both errors are NSError instances, if yes, then compare error domains, codes, and userInfo for ALL NSErrors
                if let lhsNSError = lhsError as? NSError, let rhsNSError = rhsError as? NSError {
                    return lhsNSError.domain == rhsNSError.domain &&
                           lhsNSError.code == rhsNSError.code &&
                           lhsNSError.userInfo["NSLocalizedDescription"] as? String == rhsNSError.userInfo["NSLocalizedDescription"] as? String &&
                           lhsNSError.userInfo["NSErrorFailingURLStringKey"] as? String == rhsNSError.userInfo["NSErrorFailingURLStringKey"] as? String
                }
                return false // If not NSError, we return false
            default:
                return false
        }
    }
}

final class CountriesServiceTests: XCTestCase {
    
    /** Test Setup */
    var countriesService: CountriesService!
    
    override func setUp() {
        super.setUp()
        countriesService = CountriesService()
    }
    
    override func tearDown() {
        super.tearDown()
        countriesService = nil
    }
    
    /**
        Note, the original guard is actually implemented incorrectly, error thrown is @ network lv, not @ service lv
     */
    func test_fetch_countries_invalid_url() async {
        let invalidUrlString = ["htpqweqweq_invalidString", "http", "https", "123321", "lalalal"]
        for invalidURL in invalidUrlString {
            print("Testing URL: \"\(invalidURL)\"")
            let error = NSError(
                domain: NSURLErrorDomain,
                code: NSURLErrorUnsupportedURL,
                userInfo: [
                    "NSLocalizedDescription": "unsupported URL",
                    "NSErrorFailingURLStringKey": invalidURL
                ]
            )
            let expectedError = CountriesServiceError.failure(error);
            countriesService.url_string = invalidURL;
            
            do {
                _ = try await countriesService.fetchCountries()
                XCTFail("Expected error, but function succeeded, for url: \"\(invalidURL)\"")
            } catch {
                XCTAssertEqual(error as? CountriesServiceError, expectedError, "invalid_url failed for input \"\(invalidURL)\"")
            }
        }
    }
}

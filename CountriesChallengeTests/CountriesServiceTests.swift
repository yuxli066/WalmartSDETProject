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
    setup Mock session
 */
func setupMockData() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    let mockSession = URLSession(configuration: config)
    return mockSession
}

func tearDownMockData () -> Void {
    MockURLProtocol.mockedData = nil
}

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
                /* TODO: If not NSError, we return false, we just need to test if system lv ERRORs are wrapped by .failure. We can add more custom ERRORs. */
                return false
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
        tearDownMockData()
        countriesService = nil
    }
    
    /**
        Valid URL should not throw error
     */
    func test_fetch_countries_valid_url() async {
        let defaultURLString = countriesService.url_string;
        XCTAssertNoThrow(try countriesService.validateURL(url:defaultURLString), "valid url failed for input \"\(countriesService.url_string)\"")
    }
    
    /**
         User should be able to retrieve Data without issue
     */
    func test_fetch_countries_valid_data() async throws {
        do {
            let countries = try await countriesService.fetchCountries()
            XCTAssertNotNil(countries, "Countries should not be nil")
        } catch {
            XCTFail("fetchCountries() threw an error: \(error)")
        }
    }
    
    /**
        Note, the original guard is actually implemented incorrectly, error thrown is @ network lv, not @ service lv
     */
    func test_fetch_countries_invalid_url() {
        let invalidUrlString = [
            "",
            " ",
            "invalid_url",
            "http://thisisHTTPnotHTTPS.com",
            "www.noscheme.com",
            "https://example.com/this has spaces",
            "https://example.com/path\\to\\file",
            "https://example.com/%badpercent",
            "https://example.com/..",
        ]
        for invalidURL in invalidUrlString {
            print("Testing URL: \"\(invalidURL)\"")
            let expectedError = CountriesServiceError.invalidUrl(invalidURL);
            do {
                _ = try countriesService.validateURL(url:invalidURL)
                XCTFail("Expected error, but function succeeded, for url: \"\(invalidURL)\"")
            } catch {
                XCTAssertEqual(error as? CountriesServiceError, expectedError, "invalid_url failed for input \"\(invalidURL)\"")
            }
        }
    }
    
    func test_fetch_countries_invalid_data() async {
        let expectedError = CountriesServiceError.invalidData;
        do {
            let session = setupMockData()
            let _ = try await countriesService.fetchCountries(using:session)
            XCTFail("Expected error, but function succeeded")
        } catch {
            XCTAssertEqual(error as? CountriesServiceError, expectedError, "invalid_data test failed")
        }
    }
    
    func test_fetch_countries_decoding_failure() async {
        let expectedError = CountriesServiceError.failure(CountriesParserError.decodingFailure)
        MockURLProtocol.mockedData = "Some invalid data string that should throw decoding failure".data(using: .utf8)!
        do {
            let session = setupMockData()
            let _ = try await countriesService.fetchCountries(using:session)
            XCTFail("Expected error, but function succeeded")
        } catch {
            XCTAssertEqual(error as? CountriesServiceError, expectedError, ".failure(decodingFailure) test failed")
        }
    }
    
    func test_fetch_countries_decoding_failure_500() async {
        let url_500 = "https://httpstat.us/500"
        let expectedError = CountriesServiceError.failure(CountriesParserError.decodingFailure)
        do {
            countriesService.url_string = url_500
            let _ = try await countriesService.fetchCountries()
            XCTFail("Expected error, but function succeeded")
        } catch {
            XCTAssertEqual(error as? CountriesServiceError, expectedError, ".failure(decodingFailure) 500 resp test failed")
        }
    }
    
    func test_fetch_countries_NSErrorHostName_failure() async {
        let validFormatUnfoundURL = "https://validurlbutnotvalid.com/"
        let error = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorCannotFindHost,
            userInfo: [
                "NSLocalizedDescription": "A server with the specified hostname could not be found.",
                "NSErrorFailingURLStringKey": validFormatUnfoundURL
            ]
        )
        let expectedError = CountriesServiceError.failure(error)
        do {
            countriesService.url_string = validFormatUnfoundURL
            let _ = try await countriesService.fetchCountries()
            XCTFail("Expected error, but function succeeded")
        } catch {
            XCTAssertEqual(error as? CountriesServiceError, expectedError, ".failure(NSError - hostname not found) test failed")
        }
    }
}

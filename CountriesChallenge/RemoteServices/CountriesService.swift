//
//  CountriesService.swift
//  CountriesChallenge
//

import Foundation

enum CountriesServiceError: Error {
    case failure(Error)
    case invalidUrl(String)
    case invalidData
    case decodingFailure
}

protocol CountriesServiceRequestDelegate: AnyObject {
    func didUpdate(error: Error?)
}

class CountriesService {
    
    private var urlString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    private let countriesParser = CountriesParser()
    
    public var url_string: String {
        return urlString
    }
    /**
       Validates URL String
     */
    func validateURL(url:String) throws -> URL {
        guard
            let apiURL = URL(string: url),
            apiURL.scheme == "https",
            let host = apiURL.host,
            !host.isEmpty
        else {
            throw CountriesServiceError.invalidUrl(url)
        }
        
        // use regex to check for invalid urls
        let pattern = #"^https:\/\/[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(:[0-9]+)?(\/[^\s\\]*)?$"#
        let invalidPercentagePattern = #"%(?![0-9A-Fa-f]{2}(?![0-9A-Fa-f]))"#
        
        if url.range(of: pattern, options: .regularExpression) != nil, !url.contains("..") {
            if url.range(of: invalidPercentagePattern, options: .regularExpression) != nil {
                throw CountriesServiceError.invalidUrl(url)
            } else {
                return apiURL
            }
        } else {
            throw CountriesServiceError.invalidUrl(url)
        }
    }
    
    func fetchCountries() async throws -> [Country] {
        let url = try validateURL(url:urlString)
        
        return try await withUnsafeThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    return continuation.resume(throwing: CountriesServiceError.failure(error))
                }
                guard let data = data else {
                    return continuation.resume(throwing: CountriesServiceError.invalidData)
                }
                let result = self?.countriesParser.parser(data)
                switch result {
                    case .success(let countries):
                        let countries = countries ?? []
                        return continuation.resume(returning: countries)
                    case .failure(let error):
                        return continuation.resume(throwing: CountriesServiceError.failure(error))
                    case .none:
                        return continuation.resume(returning: [])
                }
            }
            task.resume()
        }
    }
}

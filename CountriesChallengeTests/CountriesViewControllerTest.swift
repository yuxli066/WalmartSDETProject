//
//  CountryViewControllerTest.swift
//  CountriesChallengeTests
//
//  Created by Leo Li on 5/8/25.
//

@testable import CountriesChallenge
import XCTest
import Foundation

final class CountriesViewControllerTest: XCTestCase {
    
    func test_country_count() {
        
        let sampleCountries:[Country] = [
            Country(capital: "Beijing",
                    code: "CN",
                    currency: Currency(code: "CNY", name: "Chinese yuan", symbol: "¥"),
                    flag: "https://restcountries.eu/data/chn.svg",
                    language: Language(code: "zh", name: "Chinese"),
                    name: "China",
                    region: "AS"
                   ),
            Country(capital: "Beijing2",
                    code: "CN",
                    currency: Currency(code: "CNY", name: "Chinese yuan", symbol: "¥"),
                    flag: "https://restcountries.eu/data/chn.svg",
                    language: Language(code: "zh", name: "Chinese"),
                    name: "China",
                    region: "AS"
                   )
        ]
        
        // We inject 2 countries in viewModel, then we validate count
        let countryViewController = CountriesViewController()
        countryViewController.view_model.countriesSubject.send(sampleCountries)
        countryViewController.loadViewIfNeeded()
        
        // Assert the expected row count
        let actualCount = countryViewController.tableView(
            countryViewController.table_view,
            numberOfRowsInSection: 0
        )
        XCTAssertEqual(actualCount, 2)
    }
}

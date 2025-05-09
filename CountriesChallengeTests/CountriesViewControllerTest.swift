//
//  CountryViewControllerTest.swift
//  CountriesChallengeTests
//
//  Created by Leo Li on 5/8/25.
//

@testable import CountriesChallenge
import XCTest
import Foundation
import UIKit

final class CountriesViewControllerTest: XCTestCase {
    
    var countryViewController: CountriesViewController!
    
    override func setUp() {
        super.setUp()
        countryViewController = CountriesViewController()
        _ = countryViewController.view // wait for view load
        countryViewController.view_model.cancelAllTasks() // cancel all tasks for data consistency
        // We inject 3 countries in viewModel, then we validate cells rendered
        countryViewController._countries = sampleCountries
    }
    
    override func tearDown() {
        super.tearDown()
        countryViewController = nil
    }
    
    private let sampleCountries:[Country] = [
        Country(capital: "Beijing",
                code: "CN",
                currency: Currency(code: "CNY", name: "Chinese yuan", symbol: "¥"),
                flag: "https://restcountries.eu/data/chn.svg",
                language: Language(code: "zh", name: "Chinese"),
                name: "China",
                region: "AS"
               ),
        Country(capital: "Beijing2",
                code: "CN2",
                currency: Currency(code: "CNY2", name: "Chinese yuan2", symbol: "¥2"),
                flag: "https://restcountries.eu/data/chn.svg2",
                language: Language(code: "zh2", name: "Chinese2"),
                name: "China2",
                region: "AS2"
               ),
        Country(capital: "Testing Capital",
                code: "Testing Code",
                currency: Currency(code: "Testing Currency", name: "Testing Currency", symbol: "Testing Currency"),
                flag: "Testing Flag",
                language: Language(code: "Testing Lang Code", name: "Testing Lang Name"),
                name: "Testing Name",
                region: "Testing Region"
               )
    ]
    
    // num countries count
    func test_country_count() {
        // Assert the expected row count
        let actualCount = countryViewController.tableView(
            countryViewController.table_view,
            numberOfRowsInSection: 0
        )
        XCTAssertEqual(actualCount, 3)
    }
    
    // row country data rendering
    func test_cell_render_row0() {
        let testIndex = IndexPath(row: 0, section: 0) // row 0
        
        // Assert the correct cells are being displayed
        let actualCell = countryViewController.tableView(
            countryViewController.table_view,
            cellForRowAt: testIndex
        ) as? CountryCell
        
        XCTAssertEqual(actualCell?.name_and_region_label.text, "\(sampleCountries[0].name), \(sampleCountries[0].region)")
        XCTAssertEqual(actualCell?.code_label.text, sampleCountries[0].code)
        XCTAssertEqual(actualCell?.capital_label.text, sampleCountries[0].capital)
    }
    
    func test_cell_render_row1() {
        let testIndex = IndexPath(row: 1, section: 0) // row 1
        
        // Assert the correct cells are being displayed
        let actualCell = countryViewController.tableView(
            countryViewController.table_view,
            cellForRowAt: testIndex
        ) as? CountryCell
        
        XCTAssertEqual(actualCell?.name_and_region_label.text, "\(sampleCountries[1].name), \(sampleCountries[1].region)")
        XCTAssertEqual(actualCell?.code_label.text, sampleCountries[1].code)
        XCTAssertEqual(actualCell?.capital_label.text, sampleCountries[1].capital)
    }
    
    // search function
    func test_search_result_func_when_search_text_is_empty() {
        // set search bar text to empty or ""
        countryViewController.search_controller.searchBar.text = ""
        countryViewController.updateSearchResults(for: countryViewController.search_controller)
        XCTAssertEqual(countryViewController._filtered_countries.count, 3)
    }
    
    func test_search_result_func_when_search_text_is_not_empty() throws {
        // Assert the expected row count
        let actualCount = countryViewController.tableView(
            countryViewController.table_view,
            numberOfRowsInSection: 0
        )
        XCTAssertEqual(actualCount, 3)
        
        // set search bar text to custom search country name
        countryViewController.search_controller.searchBar.text = "testing".lowercased()
        countryViewController.updateSearchResults(for: countryViewController.search_controller)
        
        // Assert search res
        XCTAssertEqual(countryViewController._filtered_countries.count, 1)
        
        // need extra guard here after above assertion.
        guard countryViewController._filtered_countries.count >= 1 else {
            XCTFail("Array has fewer elements than expected: \(countryViewController._filtered_countries.count) < 1")
            return
        }
        
        XCTAssertEqual(countryViewController._filtered_countries[0].capital, sampleCountries[2].capital)
        XCTAssertEqual(countryViewController._filtered_countries[0].name, sampleCountries[2].name)
        XCTAssertEqual(countryViewController._filtered_countries[0].region, sampleCountries[2].region)
        XCTAssertEqual(countryViewController._filtered_countries[0].code, sampleCountries[2].code)
    }
}

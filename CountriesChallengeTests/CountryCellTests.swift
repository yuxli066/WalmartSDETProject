//
//  CountryCellTests.swift
//  CountriesChallengeTests
//
//  Created by Leo Li on 5/8/25.
//

@testable import CountriesChallenge
import XCTest
import Foundation

/**
 To unit test country cells, we only need to spin up an instance of a country cell,
 then test to see if the cell is configured correctly with the correct content by manually passing country data to the cell.
 */
final class CountryCellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_country_cell_configuration() {
        let mockCountry = Country(
                            capital: "Beijing",
                            code: "CN",
                            currency: Currency(code: "CNY", name: "Chinese yuan", symbol: "¥"),
                            flag: "https://restcountries.eu/data/chn.svg",
                            language: Language(code: "zh", name: "Chinese"),
                            name: "China",
                            region: "AS")
        
        let cell = CountryCell(style: .default, reuseIdentifier: CountryCell.identifier)
        cell.configure(country: mockCountry)
        
        func findLabel(withId id: String, in view: UIView) -> UILabel? {
            if let label = view as? UILabel, label.accessibilityIdentifier == id {
                return label
            }
            for subview in view.subviews {
                if let found = findLabel(withId: id, in: subview) {
                    return found
                }
            }
            return nil
        }
        
        let nameAndRegion = findLabel(withId: "nameAndRegionLabel", in: cell)
        let code = findLabel(withId: "codeLabel", in: cell)
        let capital = findLabel(withId: "capitalLabel", in: cell)
        
        XCTAssertEqual(nameAndRegion?.text, "\(mockCountry.name), \(mockCountry.region)")
        XCTAssertEqual(code?.text, mockCountry.code)
        XCTAssertEqual(capital?.text, mockCountry.capital)
    }
}

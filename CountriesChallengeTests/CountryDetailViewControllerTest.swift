//
//  CountryDetailViewControllerTest.swift
//  CountriesChallengeTests
//
//  Created by Leo Li on 5/8/25.
//

@testable import CountriesChallenge
import XCTest
import Foundation

final class CountryDetailViewControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_country_detail_view_controller_configuration() {
        let mockCountry = Country(
                            capital: "Beijing",
                            code: "CN",
                            currency: Currency(code: "CNY", name: "Chinese yuan", symbol: "¥"),
                            flag: "https://restcountries.eu/data/chn.svg",
                            language: Language(code: "zh", name: "Chinese"),
                            name: "China",
                            region: "AS")
        
        let countryDetails = CountryDetailViewController(country: mockCountry)
        countryDetails.loadViewIfNeeded()
        
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
        
        let nameAndRegion = findLabel(withId: "nameAndRegionLabel", in: countryDetails.view)
        let code = findLabel(withId: "codeLabel", in: countryDetails.view)
        let capital = findLabel(withId: "capitalLabel", in: countryDetails.view)
        
        XCTAssertEqual(nameAndRegion?.text, "\(mockCountry.name), \(mockCountry.region)")
        XCTAssertEqual(code?.text, mockCountry.code)
        XCTAssertEqual(capital?.text, mockCountry.capital)
    }

}

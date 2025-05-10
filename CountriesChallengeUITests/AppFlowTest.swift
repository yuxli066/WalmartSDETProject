//
//  AppFlowTest.swift
//  CountriesChallengeUITests
//
//  Created by Leo Li on 5/9/25.
//


import XCTest
import Foundation

/*
    ----------------------------------------
    ----------------------------------------
    Models taken from:
    ios-sdet-challenge-main/CountriesChallenge/Models/Country.swift
    ios-sdet-challenge-main/CountriesChallenge/Models/Currency.swift
    ios-sdet-challenge-main/CountriesChallenge/Models/Language.swift
    ----------------------------------------
    ----------------------------------------
*/

struct Country: Codable {
    let capital: String
    let code: String
    let currency: Currency
    let flag: String
    let language: Language
    let name: String
    let region: String
}

struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String?
}

struct Language: Codable {
    let code: String?
    let name: String
}
/*
    ----------------------------------------
    ----------------------------------------
*/

final class AppFlowTest: XCTestCase {
    
    private var app: XCUIApplication?
    private var all_countries: [Country]?
    private var countriesButton: XCUIElement?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app!.launchArguments += ["-UITestSpeedFast"]
        app!.launch()
        app!.activate()
        countriesButton = app!/*@START_MENU_TOKEN@*/.buttons["Countries"]/*[[".navigationBars.buttons[\"Countries\"]",".buttons.firstMatch",".buttons[\"Countries\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app = nil
    }
    
    func manually_import_countries() -> [Country] {
        let uiTestBundle = Bundle(for: type(of: self))
        
        guard let url = uiTestBundle.url(forResource: "countries", withExtension: "json") else {
            print("Failed to locate file.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedCountries = try JSONDecoder().decode([Country].self, from: data)
            return decodedCountries
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return []
    }
    
    func validate_every_country_cell(in app: XCUIApplication, startingIndex: Int, offset: Int = 10) {
        
        all_countries = manually_import_countries()
        let maxSwipes = 5
        let scrollView = app.tables.firstMatch

        var swipes = 0
        for index in stride(from: startingIndex, to: all_countries!.count, by: offset) {
            let currentCountry = all_countries![index]
            
            print("Checking: \(currentCountry.name)")
            let current_element = app.staticTexts["\(currentCountry.name), \(currentCountry.region)"]
            
            swipes = 0
            var elDoesNotExist = (!current_element.exists || !current_element.isHittable)
            while elDoesNotExist && swipes < maxSwipes {
                DispatchQueue.main.async {
                    scrollView.swipeUp()
                }
                swipes += 1
                elDoesNotExist = (!current_element.exists || !current_element.isHittable)
                sleep(1)
            }
            
            XCTAssertTrue(current_element.exists && current_element.isHittable, "Country element \(currentCountry.name) not found after \(maxSwipes) swipes.")
            validate_cell_details(el: current_element, currentCountry: currentCountry)
        }
    }
    
    func validate_cell_details(el: XCUIElement, currentCountry: Country) {
        let exists = el.waitForExistence(timeout: 5)
        if exists && el.isHittable {
            DispatchQueue.main.async {
                el.tap()
            }
        } else {
            XCTFail("Element not tappable")
        }
        
        let details1 = app?.staticTexts["\(currentCountry.name), \(currentCountry.region)"]
        let details2 = app?.staticTexts["\(currentCountry.code)"]
        let details3 = app?.staticTexts["\(currentCountry.capital)"]
        
        // validate details
        XCTAssertTrue(details1!.exists && details1!.isHittable)
        XCTAssertTrue(details2!.exists && details2!.isHittable)
        XCTAssertTrue(details3!.exists && details3!.isHittable)
        
        DispatchQueue.main.async {
            self.countriesButton!.tap()
        }
    }
    
    /*
      if we want to cover entire list, just keep changing index until index == offset
      etc) for startingIndex in 0...offset -> validate_every_country_cell(in: app!, startingIndex: startingIndex)
    */
    func test_all_countries() throws {
        
        validate_every_country_cell(in: app!, startingIndex: 0, offset: 20)
        
        /* below should cover every single country */
        //validate_every_country_cell(in: app!, startingIndex: 1, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 2, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 3, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 4, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 5, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 6, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 7, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 8, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 9, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 10, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 11, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 12, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 13, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 14, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 15, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 16, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 17, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 18, offset: 20)
        //validate_every_country_cell(in: app!, startingIndex: 19, offset: 20)
    }
    
    func test_search_functionality_1() throws {
        let countryToSearch = Country(
            capital: "Andorra la Vella",
            code: "AD",
            currency: Currency(code: "EUR", name: "Euro", symbol: "€"),
            flag: "https://restcountries.eu/data/and.svg",
            language: Language(code: "ca", name: "Catalan"),
            name: "Andorra",
            region: "EU"
        )
        let searchField = app!.searchFields.firstMatch
        let searchFieldExists = searchField.exists;
        XCTAssertTrue(searchFieldExists, "Search bar not found")
        
        DispatchQueue.main.async {
            searchField.tap()
            searchField.typeText(countryToSearch.capital)
            sleep(1)
        }
        
        let el = app!.staticTexts["\(countryToSearch.name), \(countryToSearch.region)"]
        let searchResult = el.waitForExistence(timeout: 5)
        XCTAssertTrue(searchResult)
        validate_cell_details(el: el, currentCountry: countryToSearch)
    }
    
    func test_search_functionality_2() throws {
        let countryToSearch = Country(
            capital: "Washington, D.C.",
            code: "US",
            currency: Currency(code: "USD", name: "United States dollar", symbol: "$"),
            flag: "https://restcountries.eu/data/usa.svg",
            language: Language(code: "ca", name: "English"),
            name: "United States of America",
            region: "NA"
        )
        let searchField = app!.searchFields.firstMatch
        let searchFieldExists = searchField.exists;
        XCTAssertTrue(searchFieldExists, "Search bar not found")
        
        DispatchQueue.main.async {
            searchField.tap()
            searchField.typeText(countryToSearch.capital)
            sleep(1)
        }
        
        let el = app!.staticTexts["\(countryToSearch.name), \(countryToSearch.region)"]
        let searchResult = el.waitForExistence(timeout: 5)
        XCTAssertTrue(searchResult)
        validate_cell_details(el: el, currentCountry: countryToSearch)
    }

}

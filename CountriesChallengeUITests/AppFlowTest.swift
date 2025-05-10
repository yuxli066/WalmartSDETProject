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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app!.launchArguments += ["-UITestSpeedFast"]
        app!.launch()
        app!.activate()
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
            while (!current_element.exists || !current_element.isHittable) && swipes < maxSwipes {
                print("swiping up!")
                DispatchQueue.main.async {
                    scrollView.swipeUp()
                }
                swipes += 1
                sleep(1)
            }
            
            XCTAssertTrue(current_element.exists && current_element.isHittable, "Country element \(currentCountry.name) not found after \(maxSwipes) swipes.")
        }
    }
    
    func test_user_lands_on_country_page() async throws {
        
        // we go through entire list of countries, validate all starting from index 0 with offset of 10 which is default
        // if we want to cover entire list, just keep changing index until index == offset
        // etc) for startingIndex in 0...offset -> validate_every_country_cell(in: app!, startingIndex: startingIndex)
        
        validate_every_country_cell(in: app!, startingIndex: 0, offset: 20)
        
        // below should cover every single country
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
}

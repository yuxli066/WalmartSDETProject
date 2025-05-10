//
//  CountriesViewModel.swift
//  CountriesChallenge
//

import Combine
import Foundation

class CountriesViewModel {
    private let service = CountriesService()

    private(set) var countriesSubject = CurrentValueSubject<[Country], Never>([])
    private(set) var errorSubject = CurrentValueSubject<Error?, Never>(nil)
    private var _countryTask: Task<Void, Never>?
    
    func refreshCountries() {
        _countryTask = Task {
            do {
                let countries = try await service.fetchCountries()
                self.countriesSubject.value = countries
            } catch {
                self.errorSubject.value = error
            }
        }
    }
}

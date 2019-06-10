//
//  RepositoryListViewModelTests.swift
//  SwiftUI-MVVMTests
//
//  Created by Yusuke Kita on 6/7/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import Combine
import XCTest
@testable import SwiftUI_MVVM

final class RepositoryListViewModelTests: XCTestCase {
    
    func test_didChange() {
        let viewModel = makeViewModel()
        var didChanges: [Bool] = []
        _ = viewModel.didChange
            .sink(receiveValue: { _ in didChanges.append(true) })
        
        let allDidChangeSubjects = [
            viewModel.didChangeRepositoriesSubject,
            viewModel.didChangeIsErrorShownSubject
        ]
        
        allDidChangeSubjects.forEach { $0.send(()) }
        XCTAssertEqual(allDidChangeSubjects.count, didChanges.count)
    }
    
    func test_updateRepositoriesWhenOnAppear() {
        let apiService = MockAPIService()
        apiService.stub(
            for: "/search/repositories",
            response: Publishers.Once<SearchRepositoryResponse, APIServiceError>(
                SearchRepositoryResponse(
                    items: [
                        .init(
                            id: 1,
                            fullName: "foo",
                            owner: .init(id: 1, login: "bar", avatarUrl: URL(string: "http://baz.com")!)
                        )
                    ]
                )
            ).eraseToAnyPublisher()
        )
        let viewModel = makeViewModel(apiService: apiService)
        var didChange = false
        _ = viewModel.didChangeRepositoriesSubject
            .sink(receiveValue: { _ in didChange = true })
        
        viewModel.apply(.onAppear)
        XCTAssertTrue(didChange)
    }
    
    func test_serviceErrorWhenOnAppear() {
        let apiService = MockAPIService()
        apiService.stub(
            for: "/search/repositories",
            response: Publishers.Once<SearchRepositoryResponse, APIServiceError>(
                APIServiceError.responseError
            ).eraseToAnyPublisher()
        )
        let viewModel = makeViewModel(apiService: apiService)
        var didChange = false
        _ = viewModel.didChangeIsErrorShownSubject
            .sink(receiveValue: { _ in didChange = true })
        
        viewModel.apply(.onAppear)
        XCTAssertTrue(didChange)
    }
    
    func test_logListViewWhenOnAppear() {
        let trackerService = MockTrackerService()
        let viewModel = makeViewModel(trackerService: trackerService)
        
        viewModel.apply(.onAppear)
        XCTAssertTrue(trackerService.loggedTypes.contains(.listView))
    }
    
    private func makeViewModel(
        apiService: APIServiceType = MockAPIService(),
        trackerService: TrackerType = MockTrackerService()
        ) -> RepositoryListViewModel {
        return RepositoryListViewModel(apiService: apiService, trackerService: trackerService)
    }
}

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
    
    func test_updateRepositoriesWhenOnAppear() {
        let apiService = MockAPIService()
        apiService.stub(for: SearchRepositoryRequest.self) { _ in
            Publishers.Once<SearchRepositoryResponse, APIServiceError>(
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
        }
        let viewModel = makeViewModel(apiService: apiService)
        viewModel.apply(.onAppear)
        XCTAssertTrue(!viewModel.output.repositories.isEmpty)
    }
    
    func test_serviceErrorWhenOnAppear() {
        let apiService = MockAPIService()
        apiService.stub(for: SearchRepositoryRequest.self) { _ in
            Publishers.Once<SearchRepositoryResponse, APIServiceError>(
                APIServiceError.responseError
                ).eraseToAnyPublisher()
        }
        let viewModel = makeViewModel(apiService: apiService)
        viewModel.apply(.onAppear)
        XCTAssertTrue(viewModel.output.isErrorShown)
    }
    
    func test_logListViewWhenOnAppear() {
        let trackerService = MockTrackerService()
        let viewModel = makeViewModel(trackerService: trackerService)
        
        viewModel.apply(.onAppear)
        XCTAssertTrue(trackerService.loggedTypes.contains(.listView))
    }
    
    func test_showIconEnabledWhenOnAppear() {
        let experimentService = MockExperimentService()
        experimentService.stubs[.showIcon] = true
        let viewModel = makeViewModel(experimentService: experimentService)

        viewModel.apply(.onAppear)
        XCTAssertTrue(viewModel.output.shouldShowIcon)
    }
    
    func test_showIconDisabledWhenOnAppear() {
        let experimentService = MockExperimentService()
        experimentService.stubs[.showIcon] = false
        let viewModel = makeViewModel(experimentService: experimentService)
        
        viewModel.apply(.onAppear)
        XCTAssertFalse(viewModel.output.shouldShowIcon)
    }
    
    private func makeViewModel(
        apiService: APIServiceType = MockAPIService(),
        trackerService: TrackerType = MockTrackerService(),
        experimentService: ExperimentServiceType = MockExperimentService()
        ) -> RepositoryListViewModel {
        return RepositoryListViewModel(
            apiService: apiService,
            trackerService: trackerService,
            experimentService: experimentService
        )
    }
}

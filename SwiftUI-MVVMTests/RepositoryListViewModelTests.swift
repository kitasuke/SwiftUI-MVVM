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
        var didChange = false
        _ = viewModel.didChange
            .sink(receiveValue: { _ in didChange = true })
        
        viewModel.responseSubject.send(.init(items: []))
        XCTAssertTrue(didChange)
    }
    
    func test_updateRepositoriesWhenOnAppear() {
        let viewModel = makeViewModel()
        var updated = false
        _ = viewModel.responseSubject
            .sink(receiveValue: { _ in updated = true })
        
        viewModel.onAppear()
        XCTAssertTrue(updated)
    }
    
    func test_logListViewWhenOnAppear() {
        let trackerService = MockTrackerService()
        let viewModel = makeViewModel(trackerService: trackerService)
        
        viewModel.onAppear()
        XCTAssertTrue(trackerService.loggedTypes.contains(.listView))
    }
    
    private func makeViewModel(
        apiService: APIServiceType = MockAPIService(),
        trackerService: TrackerType = MockTrackerService()
        ) -> RepositoryListViewModel {
        return RepositoryListViewModel(apiService: apiService, trackerService: trackerService)
    }
}

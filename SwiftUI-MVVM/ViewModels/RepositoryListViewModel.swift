//
//  ListViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/5/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class RepositoryListViewModel: BindableObject {    
    let didChange: AnyPublisher<Void, Never>
    private let didChangeSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Input
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    private(set) var repositories: [Repository] = []
    private var repositoriesStream: AnyCancellable?
    let repositoriesSubject = PassthroughSubject<[Repository], Never>()
    
    private var trackingStream: AnyCancellable?
    let trackingSubject = PassthroughSubject<TrackEventType, Never>()
    
    init(apiService: APIServiceType = APIService(),
         trackerService: TrackerType = TrackerService()) {
        didChange = repositoriesSubject
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let path = "/search/repositories"
        let queryItems: [URLQueryItem] = [
            .init(name: "q", value: "SwiftUI"),
            .init(name: "order", value: "desc")
        ]
        
        repositoriesStream = onAppearSubject
            .flatMap {
                apiService.response(from: path,queryItems: queryItems)
                    .catch { error in
                        return Publishers.Empty<SearchRepositoryResponse, Never>()
                }
            }
            .map { $0.items }
            .handleEvents(receiveOutput: { [weak self] in
                self?.repositories = $0
            })
            .subscribe(repositoriesSubject)
        
        _ = trackingSubject
            .sink { (type) in
                trackerService.log(type: type)
        }
        
        trackingStream = onAppearSubject
            .map { .listView }
            .subscribe(trackingSubject)
    }
    
    func onAppear() {
        onAppearSubject.send(())
    }
}

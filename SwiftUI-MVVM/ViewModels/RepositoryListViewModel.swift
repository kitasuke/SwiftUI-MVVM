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
    private var cancellables: [AnyCancellable] = []
    
    // MARK: Input
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    private(set) var repositories: [Repository] = []
    let responseSubject = PassthroughSubject<SearchRepositoryResponse, Never>()
    let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    let trackingSubject = PassthroughSubject<TrackEventType, Never>()
    
    init(apiService: APIServiceType = APIService(),
         trackerService: TrackerType = TrackerService()) {
        didChange = responseSubject
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let path = "/search/repositories"
        let queryItems: [URLQueryItem] = [
            .init(name: "q", value: "SwiftUI"),
            .init(name: "order", value: "desc")
        ]
        
        let responsePublisher = onAppearSubject
            .flatMap {
                apiService.response(from: path,queryItems: queryItems)
                    .catch { [weak self] error -> Publishers.Empty<SearchRepositoryResponse, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                }
            }
            .eraseToAnyPublisher()
        
        let repositoriesStream = responsePublisher
            .map { $0.items }
            .assign(to: \.repositories, on: self)
        
        let responseStream = responsePublisher
            .share()
            .subscribe(responseSubject)
        
        _ = trackingSubject
            .sink(receiveValue: trackerService.log)
        
        let trackingStream = onAppearSubject
            .map { .listView }
            .subscribe(trackingSubject)
        
        cancellables += [responseStream, repositoriesStream, trackingStream]
    }
    
    func onAppear() {
        onAppearSubject.send(())
    }
}

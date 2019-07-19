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

final class RepositoryListViewModel: BindableObject, UnidirectionalDataFlowType {
    typealias InputType = Input
    typealias OutputType = Output
    
    let willChange: AnyPublisher<Void, Never>
    private let willChangeSubject = PassthroughSubject<Void, Never>()
    private var cancellables: [AnyCancellable] = []
    
    // MARK: Input
    enum Input {
        case onAppear
    }
    func apply(_ input: Input) {
        switch input {
        case .onAppear: onAppearSubject.send(())
        }
    }
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    struct Output {
        var repositories: [Repository] = []
        var isErrorShown = false
        var errorMessage = ""
        var shouldShowIcon = false
    }
    private(set) var output = Output() {
        didSet {
            willChangeSubject.send(())
        }
    }
    // Workaround. Will be fixed later not to have redundant property for keypath setter
    var isErrorShown: Bool {
        get { return output.isErrorShown }
        set { output.isErrorShown = newValue }
    }
    
    private let responseSubject = PassthroughSubject<SearchRepositoryResponse, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private let trackingSubject = PassthroughSubject<TrackEventType, Never>()
    
    private let apiService: APIServiceType
    private let trackerService: TrackerType
    private let experimentService: ExperimentServiceType
    init(apiService: APIServiceType = APIService(),
         trackerService: TrackerType = TrackerService(),
         experimentService: ExperimentServiceType = ExperimentService()) {
        self.apiService = apiService
        self.trackerService = trackerService
        self.experimentService = experimentService
        
        willChange = willChangeSubject.eraseToAnyPublisher()
        
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        let request = SearchRepositoryRequest()
        let responsePublisher = onAppearSubject
            .flatMap { [apiService] _ in
                apiService.response(from: request)
                    .catch { [weak self] error -> Empty<SearchRepositoryResponse, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                }
        }
        
        let responseStream = responsePublisher
            .share()
            .subscribe(responseSubject)
        
        _ = trackingSubject
            .sink(receiveValue: trackerService.log)
        
        let trackingStream = onAppearSubject
            .map { .listView }
            .subscribe(trackingSubject)
        
        cancellables += [
            responseStream,
            trackingStream
        ]
    }
    
    private func bindOutputs() {
        let repositoriesStream = responseSubject
            .map { $0.items }
            .assign(to: \.output.repositories, on: self)
        
        let errorMessageStream = errorSubject
            .map { error -> String in
                switch error {
                case .responseError: return "network error"
                case .parseError: return "parse error"
                }
            }
            .assign(to: \.output.errorMessage, on: self)
        
        let errorStream = errorSubject
            .map { _ in true }
            .assign(to: \.output.isErrorShown, on: self)
        
        let showIconStream = onAppearSubject
            .map { [experimentService] _ in
                experimentService.experiment(for: .showIcon)
            }
            .assign(to: \..output.shouldShowIcon, on: self)
        
        cancellables += [
            repositoriesStream,
            errorStream,
            errorMessageStream,
            showIconStream
        ]
    }
}

//
//  RepositoryDetailViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/5/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class RepositoryDetailViewModel: BindableObject {
    let willChange: AnyPublisher<RepositoryListViewModel, Never>
    let willChangeSubject = PassthroughSubject<RepositoryListViewModel, Never>()
    
    let repository: Repository
    
    init(repository: Repository) {
        willChange = willChangeSubject.eraseToAnyPublisher()
        self.repository = repository
    }
}

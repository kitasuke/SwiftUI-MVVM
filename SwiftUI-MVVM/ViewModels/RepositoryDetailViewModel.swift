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
    let didChange: AnyPublisher<RepositoryListViewModel, Never>
    let didChangeSubject = PassthroughSubject<RepositoryListViewModel, Never>()
    
    let repository: Repository
    
    init(repository: Repository) {
        didChange = AnyPublisher(didChangeSubject)
        self.repository = repository
    }
}

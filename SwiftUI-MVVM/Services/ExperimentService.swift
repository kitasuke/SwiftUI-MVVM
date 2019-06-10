//
//  ExperimentService.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/8/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation

enum ExperimentKey: String {
    case showIcon
}

protocol ExperimentServiceType {
    func experiment(for key: ExperimentKey) -> Bool
}

final class ExperimentService: ExperimentServiceType {
    func experiment(for key: ExperimentKey) -> Bool {
        // call api to get variant for the key
        return true
    }
}

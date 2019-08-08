//
//  UnidirectionalDataFlowType.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/17/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation

protocol UnidirectionalDataFlowType {
    associatedtype InputType
    
    func apply(_ input: InputType)
}

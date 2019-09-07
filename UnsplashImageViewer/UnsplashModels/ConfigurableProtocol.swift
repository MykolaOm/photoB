//
//  ConfigurableProtocol.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/29/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import Foundation

protocol Configurator {}

protocol UnsplashConfigurator: Configurator {}

protocol Configurable {
    associatedtype T
    func configure(with model: T)
}

protocol UnsplashConfigurable: Configurable {}

//
//  ObservableObject.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import Foundation

final class ObservableObject<T> {
    
    typealias Listener = ((T?) -> Void)
    private var listener: Listener?
    
    init(_ value: T?) {
        self.value = value
    }
    
    var value: T? {
        didSet {
            self.listener?(value)
        }
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
}

//
//  Double+extensions.swift
//  DarioHealthDeemo
//
//  Created by Anton Stremovskiy on 23.11.2020.
//  Copyright © 2020 Shooting App. All rights reserved.
//

import Foundation

extension Double {
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    var format2Decimals: String {
        return String(format: "%.02f", self)
    }
    
    var format2DecimalsInch: String {
        return String(format: "%.02f˝", self)
    }
    
    var format2DecimalsCm: String {
        return String(format: "%.02f cm", self)
    }
    
    var formatToInt: Int {
        return Int(self)
    }
    
    var toString: String {
        return String(self)
    }
}

//
//  UISlider+Extension.swift
//  colorSetter
//
//  Created by Anton Saltykov on 23.08.2022.
//

import UIKit

extension UISlider {
    private static var _labels: [String: UILabel] = [:]

    var label: UILabel? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UISlider._labels[tmpAddress]
        }
        set(label) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UISlider._labels[tmpAddress] = label
        }
    }
}

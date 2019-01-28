//
//  tabBarItem.swift
//  Ubiq
//
//  Created by alumnos on 24/1/19.
//  Copyright © 2019 alumnos. All rights reserved.
//

import UIKit

class tabBarItem: UITabBarItem {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        if let image = image {
            self.image = image.withRenderingMode(.alwaysOriginal)
        }
        if let image = selectedImage {
            selectedImage = image.withRenderingMode(.alwaysOriginal)
        }
    }
}

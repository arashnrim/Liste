//
//  ListeButton.swift
//  Liste
//
//  Created by Arash Nur Iman on 20/06/20.
//  Copyright © 2020 Apprendre. All rights reserved.
//

import UIKit

class ListeButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor.init(named: "Liste Orange")!
    }
    
}

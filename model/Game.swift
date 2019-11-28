//
//  Game.swift
//  sopa_de_letras
//
//  Created by Mati on 28/11/2019.
//  Copyright © 2019 Mati. All rights reserved.
//

import Foundation
import UIKit

struct Game {
    
    init(puntos: Int, periodo: Int) {
        self.puntos = puntos
        self.periodo = periodo
        self.bonus = 0
    }
    
    var puntos: Int
    var periodo: Int
    var bonus: Int
}

//
//  Petition.swift
//  Project7
//
//  Created by Miloslav G. Milenkov on 25/06/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

//
// Created by Jani Pasanen on 2024-02-17.
//

import CouchDB

struct BookDocument: Document {
    var _id: String?
    var _rev: String?
    let title: String
    let price: Double
    let genre: String
}

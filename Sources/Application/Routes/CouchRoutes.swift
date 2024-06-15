//
// Created by Jani Pasanen on 2024-02-17.
//

import KituraContracts
import CouchDB
import LoggerAPI
import SwiftKafka

func initializeCouchRoutes(app: App) {
    // app.router.post("/couch", handler: app.couchSaveHandler)
    //app.router.post("/kafka", handler: app.couchBookDocumentSaveHandler)
    // app.router.get("/couch", handler: app.couchFindAllHandler)
    //app.router.get("/couch", handler: app.couchFindAllBookDocumentsHandler)

    /*
    app.router.post("/kafka") { (completion: (String, KafkaError?) -> Void) -> Void in

        publishMessageToChannel(app: app, message: String, topic: String, key: String = "se.jmpasanen.default.key", messageCallback: { result in
            switch result {
            case .Success:
                completion("message posted", nil)
            case let .Failure(error):
                //completion(nil, error)
                completion(nil, RequestError(.serviceUnavailable, body: error))
            }
        })
    }

     */
}


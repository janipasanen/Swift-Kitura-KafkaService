//
// Created by Jani Pasanen on 2024-02-17.
//

import Foundation
import KituraContracts
import CouchDB
import LoggerAPI

func initializeKafkaTestRoutes(app: App) {
    // app.router.post("/couch", handler: app.couchSaveHandler)
    //app.router.post("/couch", handler: app.publishMessageToChannel(app: <#T##<<error type>>#>, message: <#T##String#>, topic: <#T##String#>, messageCallback: <#T##<<error type>>#>)
    // app.router.get("/couch", handler: app.couchFindAllHandler)
    app.router.post("kafka", handler: app.postPublishMessageToChannelHandler)
   // app.router.get("/kafka", handler: app.couchFindAllBookDocumentsHandler)
}

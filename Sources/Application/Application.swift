import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import SwiftKafka

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Configure logging
        initializeLogging()
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)


        //Init CouchRoutes
        initializeCouchRoutes(app: self)

        //TODO start a Kitura subscriber
        //let config = KafkaConfig()
        //config.debug = [.all]
        let topics = ["Test", "Books", "Todos"]
        initializeKafkaTopicSubscriber(app: self, topics: topics)




    }

    public func run() throws {
        try postInit()
        //Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.addHTTPServer(onPort: 8086, with: router)
        Kitura.run()
    }
}

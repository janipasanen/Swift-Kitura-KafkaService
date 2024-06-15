//
// Created by Jani Pasanen on 2024-02-17.
//

import Foundation
import LoggerAPI
import SwiftKafka

//let subscriberQueue = DispatchQueue(label: "se.jmpasanen.kafkaSubscriberQueue").global(qos: .background)
//let subscriberQueue = DispatchQueue(label: "se.jmpasanen.kafka.subscriber.queue", attributes: .concurrent)
let subscriberQueue = DispatchQueue.global()
let couchDbSaveQueue = DispatchQueue.global()

//class KafkaSubscriber {
// https://github.com/Kitura-Next/SwiftKafka

    func initializeKafkaTopicSubscriber(app: App, topics: [String] = ["test"]) {
        subscriberQueue.async {
            Log.info("subscribeToChannel function called and executed in subscriberQueue.async.")

            do {
                let config = KafkaConfig()
                config.groupId = "Kitura"
                config.autoOffsetReset = .beginning
                let consumer = try KafkaConsumer(config: config)
                //guard consumer.connect(brokers: "localhost:9092") == 1 else {
                guard consumer.connect(brokers: "localhost:29092") == 1 else {
                    throw KafkaError(rawValue: 8)
                }
                try consumer.subscribe(topics: topics)
                while(true) {
                    let records = try consumer.poll()
                    records.forEach { record in
                        Log.info("Key: \(record.key), Topic: \(record.topic), Offset: \(record.offset), Partition: \(record.partition) Value: \(record.value)")

                        //TODO: - Implement actions based on topic, key and/or contents of value. Such as persist to database
                        // app.couchSaveHandler(book: <#T##BookDocument##Application.BookDocument#>, completion: <#T##@escaping (BookDocument?, RequestError?) -> Void##@escaping (Application.BookDocument?, KituraContracts.RequestError?) -> Swift.Void#>)
                    }

                    //print(records)
                }
            } catch {
                Log.error("Error creating consumer: \(error)")
                // print("Error creating consumer: \(error)")
            }

        }
    }


//}

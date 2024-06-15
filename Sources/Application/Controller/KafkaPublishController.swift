//
// Created by Jani Pasanen on 2024-02-17.
//

import Foundation
import KituraContracts
import CouchDB
import LoggerAPI
import SwiftKafka

let kafkaPublishQueue = DispatchQueue(label: "se.jmpasanen.message.publish.queue", attributes: .concurrent)

extension App {

    /***
    - Parameters:
    - app:
    - message:
    - topic:
    - key:
    */
    func publishMessageToChannel(message: Data, topic: String, key: String = "se.jmpasanen.default.key",
                                 messageCallback: ((Result<KafkaConsumerRecord, KafkaError>) -> Void)? = nil) {
        kafkaPublishQueue.async {
            Log.info("kafkaPublishQueue.async called in KafkaPublisher publishMessageToChannel function.")

            do {
                let producer = try KafkaProducer()
                //guard producer.connect(brokers: "localhost:9092") == 1 else {
                guard producer.connect(brokers: "localhost:29092") == 1 else {
                    throw KafkaError(rawValue: 8)
                }

                let keyData = Data(key.utf8)
                let value = message

                producer.send(producerRecord: KafkaProducerRecord(topic: topic, value: value, key: keyData)) { result in
                    switch result {
                    case .success(let message):
                        Log.info("Message at offset \(message.offset) successfully sent")
                        messageCallback!(result)
                            // print("Message at offset \(message.offset) successfully sent")
                    case .failure(let error):
                        Log.error("Error producing: \(error)")
                        messageCallback!(result)
                            //print("Error producing: \(error)")
                    }
                }
            } catch {
                Log.error("Error creating producer: \(error)")

                if let callback = messageCallback {
                    callback(.failure(KafkaError(rawValue: Int(8))))
                }

                //print("Error creating producer: \(error)")
            }
        }
    }
}

extension App {

    //func postHandler(book: BookDocument, completion: (BookDocument?, RequestError?) -> Void) {
    /**

     - Parameters:
       - book:
       - completion:
     */
    func postPublishMessageToChannelHandler(book: BookDocument, completion: @escaping (String, RequestError?) -> Void) {
        //App.codableStore.append(book)

        let jsonEncoder = JSONEncoder()
        var jsonResultData: Data

        do {
            jsonResultData = try jsonEncoder.encode(book)

            //publishMessageToChannel(message: jsonResultData, topic: <#T##String##Swift.String#>)
            publishMessageToChannel(message: jsonResultData, topic: "Books", messageCallback: { result in
                switch result {
                case .success:
                    completion("message posted to kafka queue", nil)
                case let .failure(error):
                    //completion(nil, error)
                    //completion(nil, RequestError(.serviceUnavailable, body: error))
                    completion("Error: \(error)", .internalServerError)
                }
            })

        } catch {
            completion("Error: Failed to deserialize book.", .badRequest)
        }
    }
}

/**
    - Parameters:
    - app:
    - message:
    - topic:
    - key:
*/
func publishMessageToChannel(app: App, message: String, topic: String, key: String = "se.jmpasanen.default.key",
                             messageCallback: ((Result<KafkaConsumerRecord, KafkaError>) -> Void)? = nil) {
    kafkaPublishQueue.async {
        Log.info("kafkaPublishQueue.async called in KafkaPublisher publishMessageToChannel function.")

        do {
            let producer = try KafkaProducer()
            //guard producer.connect(brokers: "localhost:9092") == 1 else {
            guard producer.connect(brokers: "localhost:29092") == 1 else {
                throw KafkaError(rawValue: 8)
            }

            let keyData = Data(key.utf8)
            let value = Data(message.utf8)

            producer.send(producerRecord: KafkaProducerRecord(topic: topic, value: value, key: keyData)) { result in
                switch result {
                case .success(let message):
                    Log.info("Message at offset \(message.offset) successfully sent")
                    messageCallback!(result)
                        // print("Message at offset \(message.offset) successfully sent")
                case .failure(let error):
                    Log.error("Error producing: \(error)")
                    messageCallback!(result)
                        //print("Error producing: \(error)")
                }
            }
        } catch {
            Log.error("Error creating producer: \(error)")

            if let callback = messageCallback {
                callback(.failure(KafkaError(rawValue: Int(8))))
            }

            //print("Error creating producer: \(error)")
        }
    }
}

//
// Created by Jani Pasanen on 2024-02-17.
//

/*
import Foundation
import LoggerAPI
import SwiftKafka

 */

//let kafkaPublishQueue = DispatchQueue.global(qos: .background)
//let kafkaPublishQueue = DispatchQueue(label: "se.jmpasanen.message.publish.queue", attributes: .concurrent)
//let couchDbReadQueue = DispatchQueue.global()
// https://www.avanderlee.com/swift/concurrent-serial-dispatchqueue/

/**
  When we publish a message to a Kafka topic, it’s distributed among the available partitions in a round-robin fashion.
 Hence, within a Kafka topic, the order of messages is guaranteed within a partition but not across partitions.

When we publish messages with a key to a Kafka topic, all messages with the same key are guaranteed to be stored
 in the same partition by Kafka. Thus, keys in Kafka messages are useful if we want to maintain order for messages
 having the same key.

 // https://github.com/Kitura-Next/SwiftKafka

 /*
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
*/


/***
    // https://www.avanderlee.com/swift/concurrent-serial-dispatchqueue/

    The best of both worlds

    In some cases, it’s valuable to benefit from the concurrent queue to perform multiple tasks at the same time while still preventing data races.
    This is possible by making use of a so-called barrier. Before we dive in, it’s good to know what a data race exactly is.
    What is a data race?

    A data race can occur when multiple threads access the same memory without synchronization and at least one access is a write.
    You could be reading values from an array from the main thread while a background thread is adding new values to that same array.

    Data races can be the root cause behind flaky tests and weird crashes.
    Therefore, it’s good practice to regularly spend time using the Thread Sanitizer.
    Using a barrier on a concurrent queue to synchronize writes

    A barrier flag can be used to make access to a certain resource or value thread-safe.
    We synchronize write access while we keep the benefit of reading concurrently.

    The following code demonstrates a messenger class that can be accessed from multiple threads at the same time.
    Adding new messages to the array is done using the barrier flag which blocks new reads until the write is finished.
 */

/*
final class Messenger {

    private var messages: [String] = []

    private var queue = DispatchQueue(label: "messages.queue", attributes: .concurrent)

    var lastMessage: String? {
        return queue.sync {
            messages.last
        }
    }

    func postMessage(_ newMessage: String) {
        queue.sync(flags: .barrier) {
            messages.append(newMessage)
        }
    }
}

 */

//let messenger = Messenger()
// Executed on Thread #1
//messenger.postMessage("Hello SwiftLee!")
// Executed on Thread #2
//print(messenger.lastMessage) // Prints: Hello SwiftLee!
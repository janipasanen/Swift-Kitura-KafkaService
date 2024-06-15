//
// Created by Jani Pasanen on 2024-02-17.
//

import Foundation
import KituraContracts
import CouchDB
import LoggerAPI

extension App {
    // Define ConnectionProperties and CouchDBClient here
    static let properties = ConnectionProperties(
            host: "127.0.0.1",              // http address
            port: 5984,                     // http port
            secured: false,                 // https or http
            username: "admin",              // admin username
            password: "password"            // admin password
    )

    static let couchDBClient = CouchDBClient(connectionProperties: properties)


    //MARK: - Handlers

    //MARK: - POST
    /**
     // https://www.kitura.dev/docs/databases/couchdb
     Since the CouchDB functions are asynchronous, we must handle responses inside the function's callback.

     - Parameters:
       - book:
       - completion:
     */
    func couchBookDocumentSaveHandler(book: BookDocument, completion: @escaping (BookDocument?, RequestError?) -> Void) {
        // Save book here
        App.couchDBClient.retrieveDB("bookstore") { (database, error) in
            guard let database = database  else {
                return completion(nil, .internalServerError)
            }
            database.create(book) { (response, error) in
                guard let response = response else {
                    return completion(nil, RequestError(httpCode: error?.statusCode ?? 500))
                }
                var updatedBook = book
                updatedBook._id = response.id
                updatedBook._rev = response.rev
                completion(updatedBook, nil)
            }
        }
    }

    func couchSaveHandler(book: BookDocument, completion: @escaping (BookDocument?, RequestError?) -> Void) {
        // Save book here
        App.couchDBClient.retrieveDB("bookstore") { (database, error) in
            guard let database = database  else {
                return completion(nil, .internalServerError)
            }
            // Initialize document here
        }
    }



    //MARK: - GET

    func couchFindAllBookDocumentsHandler(completion: @escaping ([BookDocument]?, RequestError?) -> Void) {
        // Get all books here

        func couchFindAllHandler(completion: @escaping ([BookDocument]?, RequestError?) -> Void) {
            App.couchDBClient.retrieveDB("bookstore") { (database, error) in
                guard let database = database  else {
                    return completion(nil, .internalServerError)
                }
                database.retrieveAll(includeDocuments: true, callback: { (allDocuments, error) in
                    guard let allDocuments = allDocuments else {
                        return completion(nil, RequestError(httpCode: error?.statusCode ?? 500))
                    }
                    let books = allDocuments.decodeDocuments(ofType: BookDocument.self)
                    completion(books, nil)
                })
            }
        }
    }

    func couchFindAllBookDocumentsHandlerTest(message: String, completion: @escaping ([BookDocument]?, RequestError?) -> Void) {
        // Get all books here

        func couchFindAllHandler(completion: @escaping ([BookDocument]?, RequestError?) -> Void) {
            App.couchDBClient.retrieveDB("bookstore") { (database, error) in
                guard let database = database  else {
                    return completion(nil, .internalServerError)
                }
                database.retrieveAll(includeDocuments: true, callback: { (allDocuments, error) in
                    guard let allDocuments = allDocuments else {
                        return completion(nil, RequestError(httpCode: error?.statusCode ?? 500))
                    }
                    let books = allDocuments.decodeDocuments(ofType: BookDocument.self)
                    completion(books, nil)
                })
            }
        }
    }

    func couchFindAllHandler(completion: @escaping ([BookDocument]?, RequestError?) -> Void) {
        // Get all books here
    }
}



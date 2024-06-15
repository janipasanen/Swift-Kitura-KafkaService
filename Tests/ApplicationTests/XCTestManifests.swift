import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(KituraKafkaServiceTests.allTests),
    ]
}
#endif

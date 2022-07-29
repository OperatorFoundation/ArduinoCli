import XCTest
@testable import ArduinoCli

final class ArduinoCliTests: XCTestCase {
    func testInit() throws
    {
        let cli = ArduinoCli()
        XCTAssertNotNil(cli)
    }
}

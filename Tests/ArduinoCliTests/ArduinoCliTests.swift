import XCTest
@testable import ArduinoCli

final class ArduinoCliTests: XCTestCase {
    func testInit() throws
    {
        let arduino = ArduinoCli.instance
        XCTAssertNotNil(arduino)

        if let arduino = arduino
        {
            arduino.stop()
        }
    }
}

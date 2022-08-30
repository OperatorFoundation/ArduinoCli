import XCTest
import Datable
@testable import ArduinoCli

final class ArduinoCliTests: XCTestCase {
    func testInit() throws
    {
        let cli = ArduinoCli()
        XCTAssertNotNil(cli)
    }
    
    func testLib() throws
    {
        guard let cli = ArduinoCli() else
        {
            XCTFail()
            return
        }
        
        let lib = ArduinoCliLib(cli)
        
        let install = try lib.install(library: "wordwrap")
        print(install.string)
        let deps = try lib.deps(library: "wordwrap")
        print(deps.string)
        let examples = try lib.examples(library: "wordwrap")
        print(examples.string)
        let uninstall = try lib.uninstall(library: "wordwrap")
        print(uninstall.string)
        
        XCTAssertNotNil(lib)
    }
    
    func testConfigInit() throws
    {
        guard let cli = ArduinoCli() else
        {
            XCTFail()
            return
        }
        
        let config = ArduinoCliConfig(cli)
        
        let configInit = try config.initConfig(destFile: "/Users/bluesaxorcist/Desktop/config.yaml")
        print(configInit.string)
    }
}

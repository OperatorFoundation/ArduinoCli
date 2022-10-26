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
        
        let configInit = try config.initConfig(destFile: "")
        print(configInit.string)
    }
    
    func testConfig() throws {
        guard let cli = ArduinoCli(configFile: "") else
        {
            XCTFail()
            return
        }
        
        let config = ArduinoCliConfig(cli)
        let configEnum = ArduinoCliConfig.CliConfig.self
        let _ = try config.set(flags: "debug", setting: configEnum.logging(configEnum.Logging.level))
        let _ = try config.add(flags: ["https://www.google.com"], setting: configEnum.boardManager(configEnum.BoardManager.additionalUrls))
        let dump1 = try config.dump()
        print(dump1.string)
        let _ = try config.remove(flags: ["https://www.google.com"], setting: configEnum.boardManager(configEnum.BoardManager.additionalUrls))
        let _ = try config.delete(setting: configEnum.logging(configEnum.Logging.level), deleteSubKeys: false)
        let dump2 = try config.dump()
        print(dump2.string)
    }
    
    func testCustomConfig() {
        do {
            let arduinoCliDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/ArduinoCli", isDirectory: true)
            let configURL = arduinoCliDirectory.appendingPathComponent("config.yaml", isDirectory: false)
            
            if !FileManager.default.fileExists(atPath: configURL.path)
            {
                FileManager.default.createFile(atPath: configURL.path, contents: nil)
            }
            
            // TODO: make the init fail if the config file path doesnt exist
            guard let cli = ArduinoCli(configFile: configURL.path) else
            {
                XCTFail()
                return
            }
            
            let configController = ArduinoCliConfig(cli)
            let configEnum = ArduinoCliConfig.CliConfig.self
            let userDirectoryURL = arduinoCliDirectory.appendingPathComponent("user", isDirectory: true)
            let downloadsDirectoryURL = arduinoCliDirectory.appendingPathComponent("downloads", isDirectory: true)
            let dataDirectoryURL = arduinoCliDirectory.appendingPathComponent("data", isDirectory: true)
            
            if !FileManager.default.fileExists(atPath: userDirectoryURL.path)
            {
                try FileManager.default.createDirectory(at: userDirectoryURL, withIntermediateDirectories: true)
            }
            
            XCTAssert(FileManager.default.fileExists(atPath: userDirectoryURL.path))
            
            if !FileManager.default.fileExists(atPath: downloadsDirectoryURL.path)
            {
                try FileManager.default.createDirectory(at: downloadsDirectoryURL, withIntermediateDirectories: true)
            }
            
            XCTAssert(FileManager.default.fileExists(atPath: downloadsDirectoryURL.path))
            
            if !FileManager.default.fileExists(atPath: dataDirectoryURL.path)
            {
                try FileManager.default.createDirectory(at: dataDirectoryURL, withIntermediateDirectories: true)
            }
            
            XCTAssert(FileManager.default.fileExists(atPath: dataDirectoryURL.path))
            
            let initOutput = try configController.initConfig(destDir: nil, destFile: configURL.path, overwrite: true)
            print("initOutput: \(initOutput.string)\n")
            
            let setUserDirectoryOutput = try configController.set(flags: userDirectoryURL.path, setting: configEnum.directories(configEnum.Directories.user))
            print("setUserDirectoryOutput: \(setUserDirectoryOutput.string)\n")
            
            let setDownloadsDirectoryOutput = try configController.set(flags: downloadsDirectoryURL.path, setting: configEnum.directories(configEnum.Directories.downloads))
            print("setDownloadsDirectoryOutput: \(setDownloadsDirectoryOutput.string)\n")
            
            let setDataDirectoryOutput = try configController.set(flags: dataDirectoryURL.path, setting: configEnum.directories(configEnum.Directories.data))
            print("setDataDirectoryOutput: \(setDataDirectoryOutput.string)\n")
            
            let lib = ArduinoCliLib(cli)
            let downloadOutput = try lib.download(library: "wordwrap")
            print("downloadOutput: \(downloadOutput.string)")
            
            let configFileString = try String(contentsOf: configURL)
            
            XCTAssert(configFileString.contains(dataDirectoryURL.path))
            XCTAssert(configFileString.contains(userDirectoryURL.path))
            XCTAssert(configFileString.contains(downloadsDirectoryURL.path))
        }
        catch
        {
            print("configTest failed error: \(error)")
            XCTFail()
        }
    }
}

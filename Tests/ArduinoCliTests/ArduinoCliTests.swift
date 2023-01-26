import XCTest
import Datable
import Yams
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
            let downloadOutput = try lib.install(library: "wordwrap")
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
    
    func testSketch() throws {
        // sketch.new(), core.install, board.attatch, ArduinoCli.upload
        
        let arduinoCliDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/ArduinoCli", isDirectory: true)
        let configURL = arduinoCliDirectory.appendingPathComponent("config.yaml", isDirectory: false)
        let userDir = arduinoCliDirectory.appendingPathComponent("user", isDirectory: true)
        
        guard let cli = ArduinoCli(configFile: configURL.path) else
        {
            XCTFail()
            return
        }
        
        
        let configEnum = ArduinoCliConfig.CliConfig.self
        
        let setOutput = try cli.config.set(flags: "https://adafruit.github.io/arduino-board-index/package_adafruit_index.json", setting: configEnum.boardManager(configEnum.BoardManager.additionalUrls))
        
        let sketchOutput = try cli.sketch.new(sketchName: "WordWrap", sketchPath: userDir.path)
        print("sketchOutput: \(sketchOutput.string)\n")
        
        let coreOutput = try cli.core.install(core: "adafruit:samd")
        print("coreOutput: \(coreOutput.string)\n")
        
        let searchOutput = try cli.core.search(keywords: "m4")
        print("searchOutput \(searchOutput.string)\n")
        
        let boardOutput = try cli.board.attach(sketchName: "WordWrap", boardName: "adafruit:samd:feather_m4")
        print("boardOutput: \(boardOutput.string)\n")
        
        let uploadOutput = try cli.upload(sketchPath: userDir.appendingPathComponent("WordWrap", isDirectory: true).path)
        print("uploadOutput: \(uploadOutput.string)\n")
    }
    
    func testYamlEncode() throws {
        let arduinoCliDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/ArduinoCli", isDirectory: true)
        let configURL = arduinoCliDirectory.appendingPathComponent("config.yaml", isDirectory: false)
        
        let fileData = try Data(contentsOf: configURL)
        let yamlDecoder = YAMLDecoder()
        let arduinoCliConfigFile = try yamlDecoder.decode(ArduinoCliConfigFile.self, from: fileData)
        print(arduinoCliConfigFile)
    }
    
    func testYamlFields() throws {
        let arduinoCliDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/ArduinoCli", isDirectory: true)
        let configURL = arduinoCliDirectory.appendingPathComponent("config.yaml", isDirectory: false)
        
        let fileData = try Data(contentsOf: configURL)
        let yamlDecoder = YAMLDecoder()
        let arduinoCliConfigFile = try yamlDecoder.decode(ArduinoCliConfigFile.self, from: fileData)
        let format = arduinoCliConfigFile.logging.format
        XCTAssertEqual(format, "text")
        let additionalUrls = arduinoCliConfigFile.boardManager.additionalUrls[0]
        XCTAssertEqual(additionalUrls, "https://adafruit.github.io/arduino-board-index/package_adafruit_index.json")
        let dataDirectory = arduinoCliConfigFile.directories.data
        XCTAssertEqual(dataDirectory, "/Users/bluesaxorcist/Library/ArduinoCli/data")
    }
}

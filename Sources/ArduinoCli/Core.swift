//
//  File.swift
//  
//
//  Created by Joshua Clark on 8/2/22.
//

import Foundation

import Gardener
import Transmission
import Yams

/// Arduino core operations.
/// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core/)
public class ArduinoCliCore
{
    let cli: ArduinoCli

    public init(_ cli: ArduinoCli)
    {
        self.cli = cli
    }

    public func run(_ args: String...) throws -> Data
    {
        return try self.run(args)
    }

    public func run(_ args: [String]) throws -> Data
    {
        return try self.cli.run(["core"] + args)
    }
    
    /// Downloads one or more cores and corresponding tool dependencies.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_download/)
    ///
    /// - Throws: throws if the command fails to execute
    public func download(core: String) throws -> Data
    {
        return try self.run(["download", core])
    }
    
    /// Installs one or more cores and corresponding tool dependencies.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_install/)
    ///
    /// - Parameter core: Name of the core to install
    /// - Parameter runPostInstall: Force run of post-install scripts (if the CLI is not running interactively).
    /// - Parameter skipPostInstall: Force skip of post-install scripts (if the CLI is running interactively).
    ///
    /// - Throws: throws if the command fails to execute
    ///
    /// - Note: cannot set both runPostInstall and skipPostInstall to true
    public func install(core: String, runPostInstall: Bool = false, skipPostInstall: Bool = false, urlList: [URL] = []) throws -> Data
    {
        var args: [String] = ["install", core]
        
        if runPostInstall && skipPostInstall {
            throw ArduinoCliError.conflictingArgs
        }
        
        if runPostInstall {
            args.append("--run-post-install")
        }
        
        if skipPostInstall {
            args.append("--skip-post-install")
        }
        
        let arduinoCliDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/ArduinoCli", isDirectory: true)
        let configURL = arduinoCliDirectory.appendingPathComponent("config.yaml", isDirectory: false)
        
        let fileData = try Data(contentsOf: configURL)
        let yamlDecoder = YAMLDecoder()
        let arduinoCliConfigFile = try yamlDecoder.decode(ArduinoCliConfigFile.self, from: fileData)
        let additionalUrls = arduinoCliConfigFile.boardManager.additionalUrls
        let dataDirectory = arduinoCliConfigFile.directories.data
        print("data directory: \(dataDirectory)")
        
        for urlString in additionalUrls
        {
            guard let url = URL(string: urlString) else
            {
                throw ArduinoCliCoreError.invalidUrlError
            }
            
            let fileName = url.lastPathComponent
            let dataDirectoryUrl = URL(fileURLWithPath: dataDirectory)
            let packageUrl = dataDirectoryUrl.appendingPathComponent(fileName)
            let packageData = try Data(contentsOf: url)
            try packageData.write(to: packageUrl)
        }
        
        return try self.run(args)
    }
    
    /// Shows the list of installed platforms.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_list/)
    ///
    /// - Parameter all: If set return all installable and installed cores, including manually installed
    /// - Parameter updatable: List updatable platforms.
    ///
    /// - Throws: throws if the command fails to execute
    public func list(all: Bool = false, updatable: Bool = false) throws -> Data
    {
        var args: [String] = ["list"]
        
        if all {
            args.append("--all")
        }
        
        if updatable {
            args.append("--updatable")
        }
        
        return try self.run(args)
    }
    
    /// Search for a core in Boards Manager.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_search/)
    ///
    /// - Parameter all: Show all available core versions.
    ///
    /// - Throws: throws if the command fails to execute
    public func search(keywords: String, all: Bool = false) throws -> Data
    {
        var args: [String] = ["search", keywords]
        
        if all {
            args.append("--all")
        }
        
        return try self.run(args)
    }
    
    /// Uninstalls one or more cores and corresponding tool dependencies if no longer used.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_uninstall/)
    ///
    /// - Throws: throws if the command fails to execute
    public func uninstall(cores: String) throws -> Data
    {
        return try self.run(["uninstall", cores])
    }
    
    /// Updates the index of cores to the latest version
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_update-index/)
    ///
    /// - Throws: throws if the command fails to execute
    public func updateIndex() throws -> Data
    {
        return try self.run(["update-index"])
    }
    
    /// Upgrades one or all installed platforms to the latest version.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_upgrade/)
    ///
    /// - Parameter runPostInstall: Force run of post-install scripts (if the CLI is not running interactively).
    /// - Parameter skipPostInstall: Force skip of post-install scripts (if the CLI is running interactively).
    ///
    /// - Throws: throws if the command fails to execute
    ///
    /// - Note: cannot set both runPostInstall and skipPostInstall to true
    public func upgrade(core: String? = nil, runPostInstall: Bool = false, skipPostInstall: Bool = false) throws -> Data
    {
        var args: [String] = ["upgrade"]
        
        if runPostInstall && skipPostInstall {
            throw ArduinoCliError.conflictingArgs
        }
        
        if let core = core {
            args.append(core)
        }
        
        if runPostInstall {
            args.append("--run-post-install")
        }
        
        if skipPostInstall {
            args.append("--skip-post-install")
        }
        
        return try self.run(args)
    }
}

public enum ArduinoCliCoreError: Error {
    case invalidUrlError
}

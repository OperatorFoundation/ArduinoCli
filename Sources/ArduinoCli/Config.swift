//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/31/22.
//
import Foundation

import Gardener
import Transmission

/// Arduino configuration commands
/// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config/
public class ArduinoCliConfig
{
    let cli: ArduinoCli

    public init(_ cli: ArduinoCli)
    {
        self.cli = cli
    }

    public func run(_ args: String...) throws
    {
        try self.run(args)
    }

    public func run(_ args: [String]) throws
    {
        try self.cli.run(["config"] + args)
    }
    
    /// Adds one or more values to a setting.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_add/)
    ///
    /// - Throws: throws if the command fails to execute
    public func add(flags: String) throws
    {
        try self.run(["add", flags])
    }
    
    /// Deletes a settings key and all its sub keys
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_delete/)
    ///
    /// - Throws: throws if the command fails to execute
    public func delete(flags: String) throws
    {
        try self.run(["delete", flags])
    }
    
    /// Prints the current configuration
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_dump/)
    ///
    /// - Throws: throws if the command fails to execute
    public func dump(flags: String? = nil) throws
    {
        var args: [String] = ["dump"]
        
        if let flags = flags {
            args.append(flags)
        }
        
        try self.run(args)
    }
    
    /// Writes current configuration to a configuration file
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_init/)
    ///
    /// - Parameter destDir: Sets where to save the configuration file.
    /// - Parameter destFile: Sets where to save the configuration file.
    /// - Parameter overwrite: Overwrite existing config file.
    ///
    /// - Throws: throws if the command fails to execute
    public func initConfig(destDir: String? = nil, destFile: String? = nil, overwrite: Bool = false) throws
    {
        var args: [String] = ["init"]
        
        if let destDir = destDir {
            args.append("--dest-dir")
            args.append(destDir)
        }
        
        if let destFile = destFile {
            args.append("--dest-file")
            args.append(destFile)
        }
        
        if overwrite {
            args.append("--overwrite")
        }
        
        try self.run(args)
    }
    
    /// Removes one or more values from a setting
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_remove/)
    ///
    /// - Throws: throws if the command fails to execute
    public func remove(flags: String) throws
    {
        try self.run(["remove", flags])
    }
    
    /// Sets a setting value
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_set/)
    ///
    /// - Throws: throws if the command fails to execute
    public func set(flags: String) throws
    {
        try self.run(["set", flags])
    }
}

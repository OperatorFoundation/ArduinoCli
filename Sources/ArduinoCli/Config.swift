//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/31/22.
//
import Foundation

import Gardener
import Transmission

// Arduino configuration commands
// https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config/
// FIXME: the docs on this aren't helpful
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
    
    // Adds one or more values to a setting.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_add/
    public func add(flags: String) throws
    {
        try self.run("add", flags)
    }
    
    // Deletes a settings key and all its sub keys
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_delete/
    public func delete(flags: String) throws
    {
        try self.run("delete", flags)
    }
    
    // Prints the current configuration
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_dump/
    public func dump(flags: String? = nil) throws
    {
        var args: [String] = ["dump"]
        
        if let flags = flags {
            args.append(flags)
        }
        try self.run(args)
    }
    
    // Writes current configuration to a configuration file
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_init/
    public func initConfig(destDir: String? = nil, destFile: String? = nil, overwrite: Bool = false) throws
    {
        var args: [String] = []
        
        // Sets where to save the configuration file.
        if let destDir = destDir {
            args.append("--dest-dir")
            args.append(destDir)
        }
        
        // Sets where to save the configuration file.
        if let destFile = destFile {
            args.append("--dest-file")
            args.append(destFile)
        }
        
        // Overwrite existing config file.
        if overwrite {
            args.append("--overwrite")
        }
        
        try self.run(args)
    }
    
    // Removes one or more values from a setting
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_remove/
    public func remove(flags: String) throws
    {
        try self.run("remove", flags)
    }
    
    // Sets a setting value
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_set/
    public func set(flags: String) throws
    {
        try self.run("set", flags)
    }
}

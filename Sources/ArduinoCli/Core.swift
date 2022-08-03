//
//  File.swift
//  
//
//  Created by Joshua Clark on 8/2/22.
//

import Foundation

import Gardener
import Transmission

// Arduino core operations.
// https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core/
public class ArduinoCliCore
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
        try self.cli.run(["core"] + args)
    }
    
    // Downloads one or more cores and corresponding tool dependencies.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_download/
    public func download(_ core: String) throws
    {
        try self.run("download", core)
    }
    
    // Installs one or more cores and corresponding tool dependencies.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_install/
    public func install(_ core: String, _ runPostInstall: Bool = false, _ skipPostInstall: Bool = false) throws
    {
        var args: String = ""
        
        // make sure at least one of the two options are false
        if runPostInstall && skipPostInstall {
            throw ArduinoCliError.conflictingArgs
        }
        
        // Force run of post-install scripts (if the CLI is not running interactively).
        if runPostInstall {
            args.append("--run-post-install ")
        }
        
        // Force skip of post-install scripts (if the CLI is running interactively).
        if skipPostInstall {
            args.append("--skip-post-install")
        }
        
        try self.run("install", core, args)
    }
    
    // Shows the list of installed platforms.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_list/
    public func list(_ all: Bool = false, _ updatable: Bool = false) throws
    {
        var args: String = ""
        
        // If set return all installable and installed cores, including manually installed
        if all {
            args.append("--all ")
        }
        
        // List updatable platforms.
        if updatable {
            args.append("--updatable")
        }
        
        try self.run("list", args)
    }
    
    // Search for a core in Boards Manager.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_search/
    public func search(_ keywords: String, _ all: Bool = false) throws
    {
        var args: String = ""
        
        // Show all available core versions.
        if all {
            args.append("--all")
        }
        
        try self.run("search", keywords, args)
    }
    
    // Uninstalls one or more cores and corresponding tool dependencies if no longer used.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_uninstall/
    public func uninstall(_ cores: String) throws
    {
        try self.run("uninstall", cores)
    }
    
    // Updates the index of cores to the latest version
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_update-index/
    public func updateIndex() throws
    {
        try self.run("update-index")
    }
    
    // Upgrades one or all installed platforms to the latest version.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_core_upgrade/
    public func upgrade(_ core: String?, _ runPostInstall: Bool = false, _ skipPostInstall: Bool = false) throws
    {
        var args: String = ""
        
        // make sure at least one of the two options are false
        if runPostInstall && skipPostInstall {
            throw ArduinoCliError.conflictingArgs
        }
        
        if core != nil {
            args.append("\(core!) ")
        }
        
        // Force run of post-install scripts (if the CLI is not running interactively).
        if runPostInstall {
            args.append("--run-post-install ")
        }
        
        // Force skip of post-install scripts (if the CLI is running interactively).
        if skipPostInstall {
            args.append("--skip-post-install")
        }
        
        try self.run("upgrade", args)
    }
}

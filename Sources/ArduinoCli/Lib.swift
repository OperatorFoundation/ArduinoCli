//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/31/22.
//

import Foundation

import Gardener
import Transmission

// Arduino commands about libraries
// https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib/
public class ArduinoCliLib
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
        try self.cli.run(["lib"] + args)
    }
    
    // Check dependencies status for the specified library.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_deps/
    public func deps(_ library: String) throws
    {
        
        try self.run("deps", library)
    }
    
    // Downloads one or more libraries without installing them.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_download/
    public func download(_ library: String) throws
    {
        try self.run("download", library)
    }
    
    // Shows the list of the examples for libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_examples/
    // FIXME: will the run panic if one of the fields is an empty string?
    public func examples(_ library: String, _ boardName: String?) throws
    {
        var args: String = ""
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("-b \(boardName!)")
        }
        
        try self.run("examples", library, args)
    }
    
    // Installs one or more specified libraries into the system.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_install/
    public func install(_ library: String, _ gitUrl: String?, _ noDeps: Bool = false, _ zipPath: String?) throws
    {
        var args: String = ""
        
        // Enter git url for libraries hosted on repositories
        if gitUrl != nil {
            args.append("--git-url \(gitUrl!) ")
        }
        
        // Do not install dependencies.
        if noDeps {
            args.append("--no-deps ")
        }
        
        // Enter a path to zip file
        if zipPath != nil {
            args.append("--zip-path \(zipPath!)")
        }
        
        try self.run("install", library, args)
    }
    
    // Shows a list of installed libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_list/
    public func list(_ library: String, _ all: Bool = false, _ boardName: String?, _ updateable: Bool = false) throws
    {
        var args: String = ""
        
        // Include built-in libraries (from platforms and IDE) in listing.
        if all {
            args.append("--all ")
        }
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("-b \(boardName!)")
        }
        
        // List updatable libraries.
        if updateable {
            args.append("--updatable")
        }
        
        try self.run("list", library, args)
    }
    
    // Searches for one or more libraries data.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_search/
    public func search(_ library: String, _ names: Bool = false) throws
    {
        var args: String = ""
        
        // Show library names only.
        if names {
            args.append("--names")
        }
        
        try self.run("search", library)
    }
    
    // Uninstalls one or more libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_uninstall/
    // TODO: says one or more, but currently only set up for one right?
    public func uninstall(_ library: String) throws
    {
        try self.run("uninstall", library)
    }
    
    // Updates the libraries index.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_update-index/
    public func updateIndex(_ library: String) throws
    {
        try self.run("update-index", library)
    }
    
    // Upgrades installed libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_upgrade/
    public func upgrade(_ library: String) throws
    {
        try self.run("upgrade", library)
    }
}

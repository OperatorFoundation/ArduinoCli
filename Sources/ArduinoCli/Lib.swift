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
    public func deps(library: String) throws
    {
        
        try self.run("deps", library)
    }
    
    // Downloads one or more libraries without installing them.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_download/
    public func download(library: String) throws
    {
        try self.run("download", library)
    }
    
    // Shows the list of the examples for libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_examples/
    public func examples(library: String, boardName: String?) throws
    {
        var args: [String] = ["examples", library]
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        try self.run(args)
    }
    
    // Installs one or more specified libraries into the system.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_install/
    public func install(library: String, gitUrl: String? = nil, noDeps: Bool = false, zipPath: String?) throws
    {
        var args: [String] = ["install", library]
        
        // Enter git url for libraries hosted on repositories
        if let gitUrl = gitUrl {
            args.append("--git-url")
            args.append(gitUrl)
        }
        
        // Do not install dependencies.
        if noDeps {
            args.append("--no-deps ")
        }
        
        // Enter a path to zip file
        if let zipPath = zipPath {
            args.append("--zip-path")
            args.append(zipPath)
        }
        
        try self.run(args)
    }
    
    // Shows a list of installed libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_list/
    public func list(library: String, all: Bool = false, boardName: String? = nil, updateable: Bool = false) throws
    {
        var args: [String] = ["list", library]
        
        // Include built-in libraries (from platforms and IDE) in listing.
        if all {
            args.append("--all ")
        }
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // List updatable libraries.
        if updateable {
            args.append("--updatable")
        }
        
        try self.run(args)
    }
    
    // Searches for one or more libraries data.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_search/
    public func search(library: String, names: Bool = false) throws
    {
        var args: [String] = ["search", library]
        
        // Show library names only.
        if names {
            args.append("--names")
        }
        
        try self.run(args)
    }
    
    // Uninstalls one or more libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_uninstall/
    public func uninstall(library: String) throws
    {
        try self.run("uninstall", library)
    }
    
    // Updates the libraries index.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_update-index/
    public func updateIndex(library: String) throws
    {
        try self.run("update-index", library)
    }
    
    // Upgrades installed libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_upgrade/
    public func upgrade(library: String) throws
    {
        try self.run("upgrade", library)
    }
}

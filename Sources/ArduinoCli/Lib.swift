//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/31/22.
//

import Foundation

import Gardener
import Transmission

/// Arduino commands about libraries
/// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib/)
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
    
    /// Check dependencies status for the specified library.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_deps/)
    ///
    /// - Throws: throws if the command fails to execute
    public func deps(library: String) throws
    {
        
        try self.run(["deps", library])
    }
    
    /// Downloads one or more libraries without installing them.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_download/)
    ///
    /// - Throws: throws if the command fails to execute
    public func download(library: String) throws
    {
        try self.run(["download", library])
    }
    
    /// Shows the list of the examples for libraries.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_examples/)
    ///
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    ///
    /// - Throws: throws if the command fails to execute
    public func examples(library: String, boardName: String?) throws
    {
        var args: [String] = ["examples", library]
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        try self.run(args)
    }
    
    /// Installs one or more specified libraries into the system.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_install/)
    ///
    /// - Parameter gitUrl: Enter git url for libraries hosted on repositories
    /// - Parameter noDeps: Do not install dependencies.
    /// - Parameter zipPath: Enter a path to zip file
    ///
    /// - Throws: throws if the command fails to execute
    public func install(library: String, gitUrl: String? = nil, noDeps: Bool = false, zipPath: String?) throws
    {
        var args: [String] = ["install", library]
        
        if let gitUrl = gitUrl {
            args.append("--git-url")
            args.append(gitUrl)
        }
        
        if noDeps {
            args.append("--no-deps ")
        }
        
        if let zipPath = zipPath {
            args.append("--zip-path")
            args.append(zipPath)
        }
        
        try self.run(args)
    }
    
    /// Shows a list of installed libraries.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_list/)
    ///
    /// - Parameter all: Include built-in libraries (from platforms and IDE) in listing.
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter updatable: List updatable libraries.
    ///
    /// - Throws: throws if the command fails to execute
    public func list(library: String, all: Bool = false, boardName: String? = nil, updatable: Bool = false) throws
    {
        var args: [String] = ["list", library]
        
        if all {
            args.append("--all ")
        }
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if updatable {
            args.append("--updatable")
        }
        
        try self.run(args)
    }
    
    /// Searches for one or more libraries data.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_search/)
    ///
    /// - Parameter names: Show library names only.
    ///
    /// - Throws: throws if the command fails to execute
    public func search(library: String, names: Bool = false) throws
    {
        var args: [String] = ["search", library]
        
        if names {
            args.append("--names")
        }
        
        try self.run(args)
    }
    
    /// Uninstalls one or more libraries.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_uninstall/)
    ///
    /// - Throws: throws if the command fails to execute
    public func uninstall(library: String) throws
    {
        try self.run(["uninstall", library])
    }
    
    /// Updates the libraries index.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_update-index/)
    ///
    /// - Throws: throws if the command fails to execute
    public func updateIndex(library: String) throws
    {
        try self.run(["update-index", library])
    }
    
    /// Upgrades installed libraries.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_lib_upgrade/)
    ///
    /// - Throws: throws if the command fails to execute
    public func upgrade(library: String) throws
    {
        try self.run(["upgrade", library])
    }
}

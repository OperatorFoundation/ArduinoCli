//
//  Board.swift
//  
//
//  Created by Joshua Clark on 7/31/22.
//

import Foundation

import Gardener
import Transmission

/// Arduino board commands.
/// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board/)
public class ArduinoCliBoard
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
        try self.cli.run(["board"] + args)
    }
    
    /// attatches a sketch to a board
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_attach/)
    ///
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter port: Upload port address, e.g.: COM3 or /dev/ttyACM2
    /// - Parameter portProtocol: Upload port protocol, e.g: serial
    /// - Parameter discoveryTimeout: Max time to wait for port discovery, e.g.: 30s, 1m (default 1s)
    ///
    /// - Throws: throws if the command fails to execute
    public func attatch(boardName: String? = nil, port: String? = nil, portProtocol: String? = nil, discoveryTimeout: String? = nil) throws
    {
        var args: [String] = ["attatch"]
        
        if (boardName != nil && port != nil) || (boardName == nil && port == nil) {
            print("must have either boardName or port, but not both")
            throw ArduinoCliError.conflictingArgs
        }
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        try self.run(args)
    }
    
    /// print details about a board
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_details/)
    ///
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter full: Show full board details
    /// - Parameter listProgrammers: Show list of available programmers
    ///
    /// - Throws: throws if the command fails to execute
    public func details(boardName: String? = nil, full: Bool = false, listProgrammers: Bool = false) throws
    {
        var args: [String] = ["details"]
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if full {
            args.append("-f")
        }
        
        if listProgrammers {
            args.append("--list-programmers")
        }
        
        try self.run(args)
    }
    
    /// List connected boards
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_list/)
    ///
    /// - Parameter watch: Command keeps running and prints list of connected boards whenever there is a change
    /// - Parameter discoveryTimeout: Max time to wait for port discovery, e.g.: 30s, 1m (default 1s)
    ///
    /// - Throws: throws if the command fails to execute
    public func list(watch: Bool = false, discoveryTimeout: String? = nil) throws
    {
        var args: [String] = ["list"]
        
        if watch {
            args.append("-w")
        }
        
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        try self.run(args)
    }
    
    /// List all known boards and their corresponding FQBN
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_listall/)
    ///
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter showHidden: Show also boards marked as 'hidden' in the platform
    ///
    /// - Throws: throws if the command fails to execute
    public func listAll(boardName: String? = nil, showHidden: Bool = false) throws
    {
        var args: [String] = ["listall"]
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if showHidden {
            args.append("-a")
        }
        
        try self.run(args)
    }
    
    /// List all known boards and their corresponding FQBN
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_search/)
    ///
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter showHidden: Show also boards marked as 'hidden' in the platform
    ///
    /// - Throws: throws if the command fails to execute
    public func search(boardName: String? = nil, showHidden: Bool = false) throws
    {
        var args: [String] = ["search"]
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if showHidden {
            args.append("-a")
        }
        
        try self.run(args)
    }
}

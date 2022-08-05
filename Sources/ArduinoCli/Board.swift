//
//  Board.swift
//  
//
//  Created by Joshua Clark on 7/31/22.
//

import Foundation

import Gardener
import Transmission

// Arduino board commands.
// https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board/
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
    
    // attatches a sketch to a board
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_attach/
    public func attatch(boardName: String? = nil, port: String? = nil, portProtocol: String? = nil, discoveryTimeout: String? = nil) throws
    {
        var args: [String] = ["attatch"]
        
        if (boardName != nil && port != nil) || (boardName == nil && port == nil) {
            print("must have either boardName or port, but not both")
            throw ArduinoCliError.conflictingArgs
        }
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // Upload port address, e.g.: COM3 or /dev/ttyACM2
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        // Upload port protocol, e.g: serial
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        // Max time to wait for port discovery, e.g.: 30s, 1m (default 1s)
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        try self.run(args)
    }
    
    // print details about a board
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_details/
    public func details(boardName: String? = nil, full: Bool = false, listProgrammers: Bool = false) throws
    {
        var args: [String] = ["details"]
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // Show full board details
        if full {
            args.append("-f")
        }
        
        // Show list of available programmers
        if listProgrammers {
            args.append("--list-programmers")
        }
        
        try self.run(args)
    }
    
    // List connected boards
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_list/
    public func list(watch: Bool = false, discoveryTimeout: String? = nil) throws
    {
        var args: [String] = ["list"]
        
        // Command keeps running and prints list of connected boards whenever there is a change
        if watch {
            args.append("-w")
        }
        
        // Max time to wait for port discovery, e.g.: 30s, 1m (default 1s)
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        try self.run(args)
    }
    
    // List all known boards and their corresponding FQBN
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_listall/
    public func listAll(boardName: String? = nil, showHidden: Bool = false) throws
    {
        var args: [String] = ["listall"]
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // Show also boards marked as 'hidden' in the platform
        if showHidden {
            args.append("-a")
        }
        
        try self.run(args)
    }
    
    // List all known boards and their corresponding FQBN
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_search/
    public func search(boardName: String? = nil, showHidden: Bool = false) throws
    {
        var args: [String] = ["search"]
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // Show also boards marked as 'hidden' in the platform
        if showHidden {
            args.append("-a")
        }
        
        try self.run(args)
    }
}

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
    public func attatch(_ boardName: String?, _ port: String?, _ portProtocol: String?) throws
    {
        var args: String = ""
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("-b \(boardName!) ")
        }
        
        // Upload port address, e.g.: COM3 or /dev/ttyACM2
        if port != nil {
            args.append("-p \(port!) ")
        }
        
        // Upload port protocol, e.g: serial
        if portProtocol != nil {
            args.append("-l \(portProtocol!)")
        }
        
        // FIXME: --discovery-timeout duration is an option, but how should we parse a "duration"
        // Max time to wait for port discovery, e.g.: 30s, 1m (default 1s)
        
        try self.run("attatch", args)
    }
    
    // print details about a board
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_details/
    public func details(_ boardName: String?, _ full: Bool, _ listProgrammers: Bool = false) throws
    {
        var args: String = ""
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("-b \(boardName!) ")
        }
        
        // Show full board details
        if full {
            args.append("-f ")
        }
        
        // Show list of available programmers
        if listProgrammers {
            args.append("--list-programmers")
        }
        
        try self.run("details", args)
    }
    
    // List connected boards
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_list/
    public func list(_ watch: Bool = false) throws
    {
        var args: String = ""
        
        // Command keeps running and prints list of connected boards whenever there is a change
        if watch {
            args.append("-w")
        }
        
        // FIXME: --discovery-timeout duration is an option, but how should we parse a "duration"
        // Max time to wait for port discovery, e.g.: 30s, 1m (default 1s)
        
        try self.run("list", args)
    }
    
    // List all known boards and their corresponding FQBN
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_listall/
    public func listAll(_ boardName: String?, _ showHidden: Bool = false) throws
    {
        var args: String = ""
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("\(boardName!) ")
        }
        
        // Show also boards marked as 'hidden' in the platform
        if showHidden {
            args.append("-a")
        }
        
        try self.run("listall", args)
    }
    
    // List all known boards and their corresponding FQBN
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_board_search/
    public func search(_ boardName: String?, _ showHidden: Bool = false) throws
    {
        var args: String = ""
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("\(boardName!) ")
        }
        
        // Show also boards marked as 'hidden' in the platform
        if showHidden {
            args.append("-a")
        }
        
        try self.run("listall", args)
    }
}

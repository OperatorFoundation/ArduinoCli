//
//  File.swift
//  
//
//  Created by Joshua Clark on 8/2/22.
//

import Foundation

import Gardener
import Transmission

// Arduino CLI sketch commands.
// https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_sketch/
public class ArduinoCliSketch
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
        try self.cli.run(["sketch"] + args)
    }
    
    // Creates a zip file containing all sketch files.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_sketch_archive/
    public func archive(_ sketchPath: String?, _ archivePath: String?, _ includeBuildDir: Bool = false) throws
    {
        var args: String = ""
        
        // FIXME: verify that you cant use archive path without sketch path
        if sketchPath != nil {
            args.append("\(sketchPath!) ")
            if archivePath != nil {
                args.append("\(archivePath!) ")
            }
        }
        
        // Includes build directory in the archive.
        if includeBuildDir {
            args.append("--include-build-dir")
        }
        
        try self.run("archive", args)
    }
    
    // Create a new Sketch
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_sketch_new/
    public func new(_ sketchName: String) throws
    {
        try self.run("new", sketchName)
    }
}

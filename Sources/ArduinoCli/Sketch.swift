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
    public func archive(sketchPath: String? = nil, archivePath: String? = nil, includeBuildDir: Bool = false) throws
    {
        var args: [String] = ["archive"]
        
        // FIXME: verify that you cant use archive path without sketch path
        if let sketchPath = sketchPath {
            args.append(sketchPath)
            if let archivePath = archivePath {
                args.append(archivePath)
            }
        }
        
        // Includes build directory in the archive.
        if includeBuildDir {
            args.append("--include-build-dir")
        }
        
        try self.run(args)
    }
    
    // Create a new Sketch
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_sketch_new/
    public func new(sketchName: String) throws
    {
        try self.run("new", sketchName)
    }
}

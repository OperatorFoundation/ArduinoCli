//
//  File.swift
//  
//
//  Created by Joshua Clark on 8/2/22.
//

import Foundation

import Gardener
import Transmission

/// Arduino CLI sketch commands.
/// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_sketch/
public class ArduinoCliSketch
{
    let cli: ArduinoCli

    public init(_ cli: ArduinoCli)
    {
        self.cli = cli
    }

    public func run(_ args: String...) throws -> Data
    {
        return try self.run(args)
    }

    public func run(_ args: [String]) throws -> Data
    {
        return try self.cli.run(["sketch"] + args)
    }
    
    /// Creates a zip file containing all sketch files.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_sketch_archive/\
    ///
    /// - Parameter includeBuildDir: Includes build directory in the archive.
    ///
    /// - Throws: throws if the command fails to execute
    ///
    /// - Note: archivePath can't be used without sketchPath
    public func archive(sketchPath: String? = nil, archivePath: String? = nil, includeBuildDir: Bool = false) throws -> Data
    {
        var args: [String] = ["archive"]
        
        if let sketchPath = sketchPath {
            args.append(sketchPath)
            if let archivePath = archivePath {
                args.append(archivePath)
            }
        }
        
        if includeBuildDir {
            args.append("--include-build-dir")
        }
        
        return try self.run(args)
    }
    
    /// Create a new Sketch
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_sketch_new/
    ///
    /// - Throws: throws if the command fails to execute
    public func new(sketchName: String) throws -> Data
    {
        return try self.run(["new", sketchName])
    }
}

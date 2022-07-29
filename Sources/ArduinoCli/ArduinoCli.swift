import Foundation

import Gardener
import Transmission

public class ArduinoCli
{
    public var lib: ArduinoCliLib! = nil

    public init?()
    {
        guard let isInstalled = Homebrew.isInstalled("arduino-cli") else
        {
            print("homebrew is broken or not installed")
            return nil
        }

        if !isInstalled
        {
            let _ = Homebrew.install("arduino-cli")
        }

        let lib = ArduinoCliLib(self)
        self.lib = lib
    }

    public func run(_ args: String...) throws
    {
        try self.run(args)
    }

    public func run(_ args: [String]) throws
    {
        let command = Command()
        command.addPath("/opt/homebrew/bin")

        guard let _ = command.run("arduino-cli", args) else
        {
            throw ArduinoCliError.commandFailed
        }
    }
}

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

    public func install(_ library: String) throws
    {
        try self.run("install", library)
    }
}

public enum ArduinoCliError: Error
{
    case commandFailed
}

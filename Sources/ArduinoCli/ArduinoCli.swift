import Foundation

import Gardener
import Transmission

// burn-bootloader
// cache clean (library)
// compile
// completion
// daemon
// debug
// help
// monitor
// outdated
// update
// upgrade
// upload
// version

public class ArduinoCli
{
    public var board: ArduinoCliBoard! = nil
    public var config: ArduinoCliConfig! = nil
    public var core: ArduinoCliCore! = nil
    public var lib: ArduinoCliLib! = nil
    public var sketch: ArduinoCliSketch! = nil

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

        let board = ArduinoCliBoard(self)
        self.board = board
        let config = ArduinoCliConfig(self)
        self.config = config
        let core = ArduinoCliCore(self)
        self.core = core
        let lib = ArduinoCliLib(self)
        self.lib = lib
        let sketch = ArduinoCliSketch(self)
        self.sketch = sketch
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
    
    // Upload the bootloader on the board using an external programmer.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_burn-bootloader/
    public func burnBootloader(_ boardName: String?, _ port: String?, _ programmer: String?, _ portProtocol: String?, _ verify: Bool = false) throws
    {
        // FIXME: dont know how to implement "duration"
        // --discovery-timeout duration   Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
        var args: String = ""
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("-b \(boardName!) ")
        }
        
        // Upload port address, e.g.: COM3 or /dev/ttyACM2
        if port != nil {
            args.append("-p \(port!) ")
        }
        
        // Programmer to use, e.g: atmel_ice
        if programmer != nil {
            args.append("-P \(programmer!) ")
        }
        
        // Upload port protocol, e.g: serial
        if portProtocol != nil {
            args.append("-l \(portProtocol!) ")
        }
        
        // Verify uploaded binary after the upload.
        if verify {
            args.append("-t")
        }
        
        try self.run("burn-bootloader", args)
    }
    
    // Arduino cache commands
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_cache/
    public func cacheClean() throws
    {
        try self.run("cache clean")
    }
    
    // Compiles Arduino sketches
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_compile/
    public func compile(_ buildCachePath: String?, _ buildPath: String?, _ clean: Bool = false, _ exportBinaries: Bool = false, _ boardName: String?, _ libraries: String?, _ library: String?, _ onlyCompilationDatabase: Bool = false, _ optimizeForDebug: Bool = false, _ outputDir: String?, _ port: String?, _ preprocess: Bool = false, _ programmer: String?, _ portProtocol: String?, _ quiet: Bool = false, _ showProperties: Bool = false, _ upload: Bool = false, _ verify: Bool = false, _ vidPid: String?, _ warnings: String?) throws
    {
        var args: String = ""
        
        // Builds of 'core.a' are saved into this path to be cached and reused.
        if buildCachePath != nil {
            args.append("--build-cache-path \(buildCachePath!) ")
        }
        
        // Path where to save compiled files. If omitted, a directory will be created in the default temporary path of your OS.
        if buildPath != nil {
            args.append("--build-path \(buildPath!) ")
        }
        
        // FIXME: need to figure out stringArray later
        // --build-property stringArray   Override a build property with a custom value. Can be used multiple times for multiple properties.
        
        // Optional, cleanup the build folder and do not use any cached build.
        if clean {
            args.append("--clean ")
        }
        
        // FIXME: duration
        // --discovery-timeout duration   Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
        
        // If set built binaries will be exported to the sketch folder.
        if exportBinaries {
            args.append("-e ")
        }
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if boardName != nil {
            args.append("-b \(boardName!) ")
        }
        
        // List of custom libraries dir paths separated by commas. Or can be used multiple times for multiple libraries dir paths.
        if libraries != nil {
            args.append("--libraries \(libraries!) ")
        }
        
        // List of paths to libraries root folders. Libraries set this way have top priority in case of conflicts. Can be used multiple times for different libraries.
        if library != nil {
            args.append("--library \(library!) ")
        }
        
        // Just produce the compilation database, without actually compiling. All build commands are skipped except pre* hooks.
        if onlyCompilationDatabase {
            args.append("--only-compilation-database ")
        }
        
        // Optional, optimize compile output for debugging, rather than for release.
        if optimizeForDebug {
            args.append("--optimize-for-debug ")
        }
        
        // Save build artifacts in this directory.
        if outputDir != nil {
            args.append("--output-dir \(outputDir!) ")
        }
        
        // Upload port address, e.g.: COM3 or /dev/ttyACM2
        if port != nil {
            args.append("-p \(port!) ")
        }
        
        // Print preprocessed code to stdout instead of compiling.
        if preprocess {
            args.append("--preprocess ")
        }
        
        // Programmer to use, e.g: atmel_ice
        if programmer != nil {
            args.append("-P \(programmer!) ")
        }
        
        // Upload port protocol, e.g: serial
        if portProtocol != nil {
            args.append("-l \(portProtocol!) ")
        }
        
        // Optional, suppresses almost every output.
        if quiet {
            args.append("--quiet ")
        }
        
        // Show all build properties used instead of compiling.
        if showProperties {
            args.append("--show-properties ")
        }
        
        // Upload the binary after the compilation.
        if upload {
            args.append("-u ")
        }
        
        // Verify uploaded binary after the upload.
        if verify {
            args.append("-t ")
        }
        
        // When specified, VID/PID specific build properties are used, if board supports them.
        if vidPid != nil {
            args.append("--vid-pid \(vidPid!) ")
        }
        
        // Optional, can be: none, default, more, all. Used to tell gcc which warning level to use (-W flag). (default "none")
        if warnings != nil {
            args.append("--warnings \(warnings!)")
        }
        
        try self.run("compile", args)
    }
    
    // Generates completion scripts for various shells
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_completion/
    public func completion(_ shellName: String, _ fileName: String, _ noDescriptions: Bool = false) throws
    {
        var args: String = ""
        let completionArgs = "\(shellName) > \(fileName)"
        
        // Disable completion description for shells that support it
        if noDescriptions {
            args.append("--no-descriptions")
        }

        try self.run("completion", completionArgs, args)
    }
    
    // Run as a daemon on port: 50051
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_daemon/
    public func daemon(_ daemonize: Bool = false, _ debug: Bool = false, _ debugFilter: String?, _ port: String?) throws
    {
        var args: String = ""
        
        // Do not terminate daemon process if the parent process dies
        if daemonize {
            args.append("--daemonize ")
        }
        
        // Enable debug logging of gRPC calls
        if debug {
            args.append("--debug ")
        }
        
        // Display only the provided gRPC calls
        if debugFilter != nil {
            args.append("--debug-filter \(debugFilter!) ")
        }
        
        // The TCP port the daemon will listen to
        if port != nil {
            args.append("--port \(port!)")
        }
        
        try self.run("daemon", args)
    }
}

public enum ArduinoCliError: Error
{
    case commandFailed
    case conflictingArgs
}

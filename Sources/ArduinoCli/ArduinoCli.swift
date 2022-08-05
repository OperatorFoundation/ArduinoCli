import Foundation

import Gardener
import Transmission

public class ArduinoCli
{
    // subclasses
    public var board: ArduinoCliBoard! = nil
    public var config: ArduinoCliConfig! = nil
    public var core: ArduinoCliCore! = nil
    public var lib: ArduinoCliLib! = nil
    public var sketch: ArduinoCliSketch! = nil
    
    // global args
    public var additionalUrls: String?
    public var configFile: String?
    public var format: String?
    public var help: Bool
    public var logFile: String?
    public var logFormat: String?
    public var logLevel: String?
    public var noColor: Bool
    public var verbose: Bool

    public init?(additionalUrls: String? = nil, configFile: String? = nil, format: String? = nil, help: Bool = false, logFile: String? = nil, logFormat: String? = nil, logLevel: String? = nil, noColor: Bool = false, verbose: Bool = false)
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

        self.additionalUrls = additionalUrls
        self.configFile = configFile
        self.format = format
        self.help = help
        self.logFile = logFile
        self.logFormat = logFormat
        self.logLevel = logLevel
        self.noColor = noColor
        self.verbose = verbose
        
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
        
        var globalArgs = args
        
        // Comma-separated list of additional URLs for the Boards Manager.
        if let additionalUrls = self.additionalUrls {
            globalArgs.append("--additional-urls")
            globalArgs.append(additionalUrls)
        }
        
        // The custom config file (if not specified the default will be used).
        if let configFile = self.configFile {
            globalArgs.append("--config-file")
            globalArgs.append(configFile)
        }
        
        // The output format for the logs, can be: text, json, jsonmini (default "text")
        if let format = self.format {
            globalArgs.append("--format")
            globalArgs.append(format)
        }
        
        // help for arduino-cli
        if self.help {
            globalArgs.append("-h")
        }
        
        // Path to the file where logs will be written.
        if let logFile = self.logFile {
            globalArgs.append("--log-file")
            globalArgs.append(logFile)
        }
        
        // The output format for the logs, can be: text, json
        if let logFormat = self.logFormat {
            globalArgs.append("--log-format")
            globalArgs.append(logFormat)
        }
        
        // Messages with this level and above will be logged. Valid levels are: trace, debug, info, warn, error, fatal, panic
        if let logLevel = self.logLevel {
            globalArgs.append("--log-level")
            globalArgs.append(logLevel)
        }
        
        // Disable colored output.
        if self.noColor {
            globalArgs.append("--no-color")
        }

        // Print the logs on the standard output.
        if self.verbose {
            globalArgs.append("-v")
        }
        
        guard let _ = command.run("arduino-cli", globalArgs) else
        {
            throw ArduinoCliError.commandFailed
        }
    }
    
    // Upload the bootloader on the board using an external programmer.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_burn-bootloader/
    public func burnBootloader(discoveryTimeout: String? = nil, boardName: String? = nil, port: String? = nil, programmer: String? = nil, portProtocol: String? = nil, verify: Bool = false) throws
    {
        var args: [String] = ["burn-bootloader"]
        
        // --discovery-timeout duration   Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
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
        
        // Programmer to use, e.g: atmel_ice
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        // Upload port protocol, e.g: serial
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        // Verify uploaded binary after the upload.
        if verify {
            args.append("-t")
        }
        
        try self.run(args)
    }
    
    // Arduino cache commands
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_cache/
    public func cacheClean() throws
    {
        try self.run("cache clean")
    }
    
    // Compiles Arduino sketches
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_compile/
    public func compile(buildCachePath: String? = nil, buildPath: String? = nil, buildProperty: [String]?, clean: Bool = false, discoveryTimeout: String? = nil, exportBinaries: Bool = false, boardName: String? = nil, libraries: String? = nil, library: String? = nil, onlyCompilationDatabase: Bool = false, optimizeForDebug: Bool = false, outputDir: String? = nil, port: String? = nil, preprocess: Bool = false, programmer: String? = nil, portProtocol: String? = nil, quiet: Bool = false, showProperties: Bool = false, upload: Bool = false, verify: Bool = false, vidPid: String? = nil, warnings: String? = nil) throws
    {
        var args: [String] = ["compile"]
        
        // Builds of 'core.a' are saved into this path to be cached and reused.
        if let buildCachePath = buildCachePath {
            args.append("--build-cache-path")
            args.append(buildCachePath)
        }
        
        // Path where to save compiled files. If omitted, a directory will be created in the default temporary path of your OS.
        if let buildPath = buildPath {
            args.append("--build-path")
            args.append(buildPath)
        }
        
        // Override a build property with a custom value. Can be used multiple times for multiple properties.
        if let buildProperty = buildProperty {
            let buildPropertyList = buildProperty.flatMap { instance in
                return ["--build-property", instance]
            }
            args.append(contentsOf: buildPropertyList)
        }
        
        // Optional, cleanup the build folder and do not use any cached build.
        if clean {
            args.append("--clean")
        }
        
        // --discovery-timeout duration   Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        // If set built binaries will be exported to the sketch folder.
        if exportBinaries {
            args.append("-e")
        }
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // List of custom libraries dir paths separated by commas. Or can be used multiple times for multiple libraries dir paths.
        if let libraries = libraries {
            args.append("--libraries")
            args.append(libraries)
        }
        
        // List of paths to libraries root folders. Libraries set this way have top priority in case of conflicts. Can be used multiple times for different libraries.
        if let library = library {
            args.append("--library")
            args.append(library)
        }
        
        // Just produce the compilation database, without actually compiling. All build commands are skipped except pre* hooks.
        if onlyCompilationDatabase {
            args.append("--only-compilation-database")
        }
        
        // Optional, optimize compile output for debugging, rather than for release.
        if optimizeForDebug {
            args.append("--optimize-for-debug")
        }
        
        // Save build artifacts in this directory.
        if let outputDir = outputDir {
            args.append("--output-dir")
            args.append(outputDir)
        }
        
        // Upload port address, e.g.: COM3 or /dev/ttyACM2
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        // Print preprocessed code to stdout instead of compiling.
        if preprocess {
            args.append("--preprocess")
        }
        
        // Programmer to use, e.g: atmel_ice
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        // Upload port protocol, e.g: serial
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        // Optional, suppresses almost every output.
        if quiet {
            args.append("--quiet")
        }
        
        // Show all build properties used instead of compiling.
        if showProperties {
            args.append("--show-properties")
        }
        
        // Upload the binary after the compilation.
        if upload {
            args.append("-u")
        }
        
        // Verify uploaded binary after the upload.
        if verify {
            args.append("-t")
        }
        
        // When specified, VID/PID specific build properties are used, if board supports them.
        if let vidPid = vidPid {
            args.append("--vid-pid")
            args.append(vidPid)
        }
        
        // Optional, can be: none, default, more, all. Used to tell gcc which warning level to use (-W flag). (default "none")
        if let warnings = warnings {
            args.append("--warnings")
            args.append(warnings)
        }
        
        try self.run(args)
    }
    
    // Generates completion scripts for various shells
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_completion/
    public func completion(shellName: String, fileName: String, noDescriptions: Bool = false) throws
    {
        var args: [String] = ["completion", shellName, ">", fileName]
        
        // Disable completion description for shells that support it
        if noDescriptions {
            args.append("--no-descriptions")
        }

        try self.run(args)
    }
    
    // Run as a daemon on port: 50051
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_daemon/
    public func daemon(daemonize: Bool = false, debug: Bool = false, debugFilter: String? = nil, port: String? = nil) throws
    {
        var args: [String] = ["daemon"]
        
        // Do not terminate daemon process if the parent process dies
        if daemonize {
            args.append("--daemonize")
        }
        
        // Enable debug logging of gRPC calls
        if debug {
            args.append("--debug")
        }
        
        // Display only the provided gRPC calls
        if let debugFilter = debugFilter {
            args.append("--debug-filter")
            args.append(debugFilter)
        }
        
        // The TCP port the daemon will listen to
        if let port = port {
            args.append("--port")
            args.append(port)
        }
        
        try self.run(args)
    }
    
    // Debug Arduino sketches. (this command opens an interactive gdb session)
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_debug/
    public func debug(discoveryTimeout: String? = nil, boardName: String? = nil, info: Bool = false, inputDir: String? = nil, interpreter: String? = nil, port: String? = nil, programmer: String? = nil, portProtocol: String? = nil) throws
    {
        var args: [String] = ["debug"]
        
        // Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // Show metadata about the debug session instead of starting the debugger.
        if info {
            args.append("-I")
        }
        
        // Directory containing binaries for debug.
        if let inputDir = inputDir {
            args.append("--input-dir")
            args.append(inputDir)
        }
        
        // Debug interpreter e.g.: console, mi, mi1, mi2, mi3 (default "console")
        if let interpreter = interpreter {
            args.append("--interpreter")
            args.append(interpreter)
        }
        
        // Upload port address, e.g.: COM3 or /dev/ttyACM2
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        // Programmer to use, e.g: atmel_ice
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        // Upload port protocol, e.g: serial
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        try self.run(args)
    }
    
    // Open a communication port with a board.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_monitor/
    public func monitor(config: String? = nil, describe: Bool = false, discoveryTimeout: String? = nil, boardName: String? = nil, port: String? = nil, portProtocol: String? = nil, quiet: Bool = false) throws
    {
        var args: [String] = ["monitor"]
        
        // Configuration of the port.
        if let config = config {
            args.append("--config")
            args.append(config)
        }
        
        // Show all the settings of the communication port.
        if describe {
            args.append("--describe")
        }
        
        // Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
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
        
        // Run in silent mode, show only monitor input and output.
        if quiet {
            args.append("-q")
        }
        
        try self.run(args)
    }
    
    // Lists cores and libraries that can be upgraded
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_outdated/
    public func outdated() throws
    {
        try self.run("outdated")
    }
    
    // Updates the index of cores and libraries
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_update/
    public func update(showOutdated: Bool = false) throws
    {
        var args: [String] = ["update"]
        
        // Show outdated cores and libraries after index update
        if showOutdated {
            args.append("--show-outdated")
        }
        
        try self.run(args)
    }
    
    // Upgrades installed cores and libraries.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_upgrade/
    public func upgrade(runPostInstall: Bool = false, skipPostInstall: Bool = false) throws
    {
        var args: [String] = ["upgrade"]
        
        // make sure at least one of the two options are false
        if runPostInstall && skipPostInstall {
            throw ArduinoCliError.conflictingArgs
        }
        
        // Force run of post-install scripts (if the CLI is not running interactively).
        if runPostInstall {
            args.append("--run-post-install")
        }
        
        // Force skip of post-install scripts (if the CLI is running interactively).
        if skipPostInstall {
            args.append("--skip-post-install")
        }
        
        try self.run(args)
    }
    
    // Upload Arduino sketches.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_upload/
    public func upload(discoveryTimeout: String? = nil, boardName: String? = nil, inputDir: String? = nil, inputFile: String? = nil, port: String? = nil, programmer: String? = nil, portProtocol: String? = nil, verify: Bool = false) throws
    {
        var args: [String] = ["upload"]
        
        // Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        // Fully Qualified Board Name, e.g.: arduino:avr:uno
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        // Directory containing binaries to upload.
        if let inputDir = inputDir {
            args.append("--input-dir")
            args.append(inputDir)
        }
        
        // Binary file to upload.
        if let inputFile = inputFile {
            args.append("-i")
            args.append(inputFile)
        }
        
        // Upload port address, e.g.: COM3 or /dev/ttyACM2
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        // Programmer to use, e.g: atmel_ice
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        // Upload port protocol, e.g: serial
        if let portProtocol = portProtocol {
            args.append("l")
            args.append(portProtocol)
        }
        
        // Verify uploaded binary after the upload.
        if verify {
            args.append("-t")
        }
        
        try self.run(args)
    }
    
    // Shows version number of Arduino CLI.
    // https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_version/
    public func version() throws
    {
        try self.run("version")
    }
}

public enum ArduinoCliError: Error
{
    case commandFailed
    case conflictingArgs
}

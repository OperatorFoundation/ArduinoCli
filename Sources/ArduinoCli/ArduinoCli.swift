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

    public func run(_ args: String...) throws -> Data
    {
        return try self.run(args)
    }

    public func run(_ args: [String]) throws -> Data
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
        
        guard let (exitCode, output, _) = command.run("arduino-cli", globalArgs) else
        {
            throw ArduinoCliError.commandFailed
        }
        
        guard exitCode == 0 else {
            throw ArduinoCliError.commandFailed
        }
        
        return output
    }
    
    /// Upload the bootloader on the board using an external programmer.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_burn-bootloader/)
    ///
    /// - Parameter discoveryTimeout: Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter port: Upload port address, e.g.: COM3 or /dev/ttyACM2
    /// - Parameter programmer: Programmer to use, e.g: atmel_ice
    /// - Parameter portProtocol: Upload port protocol, e.g: serial
    /// - Parameter verify: Verify uploaded binary after the upload.
    ///
    /// - Throws: throws if the command fails to execute
    public func burnBootloader(discoveryTimeout: String? = nil, boardName: String? = nil, port: String? = nil, programmer: String? = nil, portProtocol: String? = nil, verify: Bool = false) throws -> Data
    {
        var args: [String] = ["burn-bootloader"]
        
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        if verify {
            args.append("-t")
        }
        
        return try self.run(args)
    }
    
    /// Arduino cache commands
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_cache/)
    ///
    /// - Throws: throws if the command fails to execute
    public func cacheClean() throws -> Data
    {
        let args: [String] = ["cache", "clean"]
        return try self.run(args)
    }
    
    /// Compiles Arduino sketches
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_compile/)
    ///
    /// - Parameter buildCachePath: Builds of 'core.a' are saved into this path to be cached and reused.
    /// - Parameter buildPath: Path where to save compiled files. If omitted, a directory will be created in the default temporary path of your OS.
    /// - Parameter buildProperty: Override a build property with a custom value. Can be used multiple times for multiple properties.
    /// - Parameter clean: Optional, cleanup the build folder and do not use any cached build.
    /// - Parameter discoveryTimeout: Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
    /// - Parameter exportBinaries: If set built binaries will be exported to the sketch folder.
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter libraries: List of custom libraries dir paths separated by commas. Or can be used multiple times for multiple libraries dir paths.
    /// - Parameter library: List of paths to libraries root folders. Libraries set this way have top priority in case of conflicts. Can be used multiple times for different libraries.
    /// - Parameter onlyCompilationDatabase: Just produce the compilation database, without actually compiling. All build commands are skipped except pre* hooks.
    /// - Parameter optimizeForDebug: Optional, optimize compile output for debugging, rather than for release.
    /// - Parameter outputDir: Save build artifacts in this directory.
    /// - Parameter port: Upload port address, e.g.: COM3 or /dev/ttyACM2
    /// - Parameter preprocess: Print preprocessed code to stdout instead of compiling.
    /// - Parameter programmer: Programmer to use, e.g: atmel_ice
    /// - Parameter portProtocol: Upload port protocol, e.g: serial
    /// - Parameter quiet: Optional, suppresses almost every output.
    /// - Parameter showProperties: Show all build properties used instead of compiling.
    /// - Parameter upload: Upload the binary after the compilation.
    /// - Parameter verify: Verify uploaded binary after the upload.
    /// - Parameter vidPid: When specified, VID/PID specific build properties are used, if board supports them.
    /// - Parameter warnings: Optional, can be: none, default, more, all. Used to tell gcc which warning level to use (-W flag). (default "none")
    ///
    /// - Throws: throws if the command fails to execute
    public func compile(buildCachePath: String? = nil, buildPath: String? = nil, buildProperty: [String]?, clean: Bool = false, discoveryTimeout: String? = nil, exportBinaries: Bool = false, boardName: String? = nil, libraries: String? = nil, library: String? = nil, onlyCompilationDatabase: Bool = false, optimizeForDebug: Bool = false, outputDir: String? = nil, port: String? = nil, preprocess: Bool = false, programmer: String? = nil, portProtocol: String? = nil, quiet: Bool = false, showProperties: Bool = false, upload: Bool = false, verify: Bool = false, vidPid: String? = nil, warnings: String? = nil) throws -> Data
    {
        var args: [String] = ["compile"]
        
        if let buildCachePath = buildCachePath {
            args.append("--build-cache-path")
            args.append(buildCachePath)
        }
        
        if let buildPath = buildPath {
            args.append("--build-path")
            args.append(buildPath)
        }
        
        if let buildProperty = buildProperty {
            let buildPropertyList = buildProperty.flatMap { instance in
                return ["--build-property", instance]
            }
            args.append(contentsOf: buildPropertyList)
        }
        
        if clean {
            args.append("--clean")
        }
        
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        if exportBinaries {
            args.append("-e")
        }
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if let libraries = libraries {
            args.append("--libraries")
            args.append(libraries)
        }
        
        if let library = library {
            args.append("--library")
            args.append(library)
        }
        
        if onlyCompilationDatabase {
            args.append("--only-compilation-database")
        }
        
        if optimizeForDebug {
            args.append("--optimize-for-debug")
        }
        
        if let outputDir = outputDir {
            args.append("--output-dir")
            args.append(outputDir)
        }
        
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        if preprocess {
            args.append("--preprocess")
        }
        
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        if quiet {
            args.append("--quiet")
        }
        
        if showProperties {
            args.append("--show-properties")
        }
        
        if upload {
            args.append("-u")
        }
        
        if verify {
            args.append("-t")
        }
        
        if let vidPid = vidPid {
            args.append("--vid-pid")
            args.append(vidPid)
        }
        
        if let warnings = warnings {
            args.append("--warnings")
            args.append(warnings)
        }
        
        return try self.run(args)
    }
    
    /// Generates completion scripts for various shells
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_completion/)
    ///
    /// - Parameter shellName: Name of shell to generate completion script for
    /// - Parameter fileName: Name of file to save the completion script to
    /// - Parameter noDescriptions: Disable completion description for shells that support it
    ///
    /// - Throws: throws if the command fails to execute
    public func completion(shellName: String, fileName: String, noDescriptions: Bool = false) throws -> Data
    {
        var args: [String] = ["completion", shellName, ">", fileName]
        
        if noDescriptions {
            args.append("--no-descriptions")
        }

        return try self.run(args)
    }
    
    /// Run as a daemon on port: 50051
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_daemon/)
    ///
    /// - Parameter daemonize: Do not terminate daemon process if the parent process dies
    /// - Parameter debug: Enable debug logging of gRPC calls
    /// - Parameter debugFilter: Display only the provided gRPC calls
    /// - Parameter port: The TCP port the daemon will listen to
    ///
    /// - Throws: throws if the command fails to execute
    public func daemon(daemonize: Bool = false, debug: Bool = false, debugFilter: String? = nil, port: String? = nil) throws -> Data
    {
        var args: [String] = ["daemon"]
        
        if daemonize {
            args.append("--daemonize")
        }
        
        if debug {
            args.append("--debug")
        }
        
        if let debugFilter = debugFilter {
            args.append("--debug-filter")
            args.append(debugFilter)
        }
        
        if let port = port {
            args.append("--port")
            args.append(port)
        }
        
        return try self.run(args)
    }
    
    /// Debug Arduino sketches. (this command opens an interactive gdb session)
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_debug/)
    ///
    /// - Parameter discoveryTimeout: Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter info: Show metadata about the debug session instead of starting the debugger.
    /// - Parameter inputDir: Directory containing binaries for debug.
    /// - Parameter interpreter: Debug interpreter e.g.: console, mi, mi1, mi2, mi3 (default "console")
    /// - Parameter port: Upload port address, e.g.: COM3 or /dev/ttyACM2
    /// - Parameter programmer: Programmer to use, e.g: atmel_ice
    /// - Parameter portProtocol: Upload port protocol, e.g: serial
    ///
    /// - Throws: throws if the command fails to execute
    public func debug(discoveryTimeout: String? = nil, boardName: String? = nil, info: Bool = false, inputDir: String? = nil, interpreter: String? = nil, port: String? = nil, programmer: String? = nil, portProtocol: String? = nil) throws -> Data
    {
        var args: [String] = ["debug"]
        
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if info {
            args.append("-I")
        }
        
        if let inputDir = inputDir {
            args.append("--input-dir")
            args.append(inputDir)
        }
        
        if let interpreter = interpreter {
            args.append("--interpreter")
            args.append(interpreter)
        }
        
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        if let portProtocol = portProtocol {
            args.append("-l")
            args.append(portProtocol)
        }
        
        return try self.run(args)
    }
    
    /// Open a communication port with a board.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_monitor/)
    ///
    /// - Parameter config: Configuration of the port.
    /// - Parameter describe: Show all the settings of the communication port.
    /// - Parameter discoveryTimeout: Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter port: Upload port address, e.g.: COM3 or /dev/ttyACM2
    /// - Parameter portProtocol: Upload port protocol, e.g: serial
    /// - Parameter quiet: Run in silent mode, show only monitor input and output.
    ///
    /// - Throws: throws if the command fails to execute
    public func monitor(config: String? = nil, describe: Bool = false, discoveryTimeout: String? = nil, boardName: String? = nil, port: String? = nil, portProtocol: String? = nil, quiet: Bool = false) throws -> Data
    {
        var args: [String] = ["monitor"]
        
        if let config = config {
            args.append("--config")
            args.append(config)
        }
        
        if describe {
            args.append("--describe")
        }
        
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
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
        
        if quiet {
            args.append("-q")
        }
        
        return try self.run(args)
    }
    
    /// Lists cores and libraries that can be upgraded
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_outdated/)
    ///
    /// - Throws: throws if the command fails to execute
    public func outdated() throws -> Data
    {
        return try self.run("outdated")
    }
    
    /// Updates the index of cores and libraries
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_update/)
    ///
    /// - Parameter showOutdated: Show outdated cores and libraries after index update
    ///
    /// - Throws: throws if the command fails to execute
    public func update(showOutdated: Bool = false) throws -> Data
    {
        var args: [String] = ["update"]
        
        if showOutdated {
            args.append("--show-outdated")
        }
        
        return try self.run(args)
    }
    
    /// Upgrades installed cores and libraries.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_upgrade/)
    ///
    /// - Parameter runPostInstall: Force run of post-install scripts (if the CLI is not running interactively).
    /// - Parameter skipPostInstall: Force skip of post-install scripts (if the CLI is running interactively).
    ///
    /// - Throws: throws if the command fails to execute
    ///
    /// - Note: runPostInstall and skipPostInstall cannot both be true.
    public func upgrade(runPostInstall: Bool = false, skipPostInstall: Bool = false) throws -> Data
    {
        var args: [String] = ["upgrade"]
        
        if runPostInstall && skipPostInstall {
            throw ArduinoCliError.conflictingArgs
        }
        
        if runPostInstall {
            args.append("--run-post-install")
        }
        
        if skipPostInstall {
            args.append("--skip-post-install")
        }
        
        return try self.run(args)
    }
    
    /// Upload Arduino sketches.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_upload/)
    ///
    /// - Parameter discoveryTimeout: Max time to wait for port discovery, e.g.: 30s, 1m (default 5s)
    /// - Parameter boardName: Fully Qualified Board Name, e.g.: arduino:avr:uno
    /// - Parameter inputDir: Directory containing binaries to upload.
    /// - Parameter inputFile: Binary file to upload.
    /// - Parameter port: Upload port address, e.g.: COM3 or /dev/ttyACM2
    /// - Parameter programmer: Programmer to use, e.g: atmel_ice
    /// - Parameter portProtocol: Upload port protocol, e.g: serial
    /// - Parameter verify: Verify uploaded binary after the upload.
    ///
    /// - Throws: throws if the command fails to execute
    public func upload(discoveryTimeout: String? = nil, boardName: String? = nil, inputDir: String? = nil, inputFile: String? = nil, port: String? = nil, programmer: String? = nil, portProtocol: String? = nil, verify: Bool = false) throws -> Data
    {
        var args: [String] = ["upload"]
        
        if let discoveryTimeout = discoveryTimeout {
            args.append("--discovery-timeout")
            args.append(discoveryTimeout)
        }
        
        if let boardName = boardName {
            args.append("-b")
            args.append(boardName)
        }
        
        if let inputDir = inputDir {
            args.append("--input-dir")
            args.append(inputDir)
        }
        
        if let inputFile = inputFile {
            args.append("-i")
            args.append(inputFile)
        }
        
        if let port = port {
            args.append("-p")
            args.append(port)
        }
        
        if let programmer = programmer {
            args.append("-P")
            args.append(programmer)
        }
        
        if let portProtocol = portProtocol {
            args.append("l")
            args.append(portProtocol)
        }
        
        if verify {
            args.append("-t")
        }
        
        return try self.run(args)
    }
    
    /// Shows version number of Arduino CLI.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_version/)
    ///
    /// - Throws: throws if the command fails to execute
    public func version() throws -> Data
    {
        return try self.run(["version"])
    }
}

public enum ArduinoCliError: Error
{
    case commandFailed
    case conflictingArgs
}

//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/31/22.
//
import Foundation

import Gardener
import Transmission

/// Arduino configuration commands
/// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config/
public class ArduinoCliConfig
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
        return try self.cli.run(["config"] + args)
    }
    
    /// Adds one or more values to a setting.
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_add/)
    ///
    /// - Throws: throws if the command fails to execute
    public func add(flags: [String], setting: CliConfig) throws -> Data
    {
        var args: [String] = ["config", "add"]
        
        switch setting {
            case .boardManager(.additionalUrls):
                args.append("board_manager.additional_urls")
            case .daemon(.port):
                args.append("daemon.port")
            case .directories(.data):
                args.append("directories.data")
            case .directories(.downloads):
                args.append("directories.downloads")
            case .directories(.user):
                args.append("directories.user")
            case .library(.enableUnsafeInstall):
                args.append("library.enable_unsafe_install")
            case .logging(.format):
                args.append("logging.format")
            case .logging(.file):
                args.append("logging.file")
            case .logging(.level):
                args.append("logging.level")
            case .metrics(.addr):
                args.append("metrics.addr")
            case .metrics(.enable):
                args.append("metrics.enable")
            case .output(.noColor):
                args.append("output.no_color")
            case .sketch(.alwaysSupportBinaries):
                args.append("sketch.always_support_binaries")
            case .updater(.enableNotification):
                args.append("updater.enable_notification")
        }
        
        args += flags
        return try self.run(args)
    }
    
    /// Deletes a settings key and all its sub keys
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_delete/)
    ///
    /// - Throws: throws if the command fails to execute
    public func delete(flags: String, setting: CliConfig, deleteSubKeys: Bool) throws -> Data
    {
        var args: [String] = ["config", "delete"]
        
        if deleteSubKeys {
            switch setting {
                case .boardManager(_):
                    args.append("board_manager")
                case .daemon(_):
                    args.append("daemon")
                case .directories(_):
                    args.append("directories")
                case .library(_):
                    args.append("library")
                case .logging(_):
                    args.append("logging")
                case .metrics(_):
                    args.append("metrics")
                case .output(_):
                    args.append("output")
                case .sketch(_):
                    args.append("sketch")
                case .updater(_):
                    args.append("updater")
            }
        } else {
            switch setting {
                case .boardManager(.additionalUrls):
                    args.append("board_manager.additional_urls")
                case .daemon(.port):
                    args.append("daemon.port")
                case .directories(.data):
                    args.append("directories.data")
                case .directories(.downloads):
                    args.append("directories.downloads")
                case .directories(.user):
                    args.append("directories.user")
                case .library(.enableUnsafeInstall):
                    args.append("library.enable_unsafe_install")
                case .logging(.format):
                    args.append("logging.format")
                case .logging(.file):
                    args.append("logging.file")
                case .logging(.level):
                    args.append("logging.level")
                case .metrics(.addr):
                    args.append("metrics.addr")
                case .metrics(.enable):
                    args.append("metrics.enable")
                case .output(.noColor):
                    args.append("output.no_color")
                case .sketch(.alwaysSupportBinaries):
                    args.append("sketch.always_support_binaries")
                case .updater(.enableNotification):
                    args.append("updater.enable_notification")
            }
        }
        
        args.append(flags)
        return try self.run(args)
    }
    
    /// Prints the current configuration
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_dump/)
    ///
    /// - Throws: throws if the command fails to execute
    public func dump(flags: String? = nil) throws -> Data
    {
        var args: [String] = ["dump"]
        
        if let flags = flags {
            args.append(flags)
        }
        
        return try self.run(args)
    }
    
    /// Writes current configuration to a configuration file
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_init/)
    ///
    /// - Parameter destDir: Sets where to save the configuration file.
    /// - Parameter destFile: Sets where to save the configuration file.
    /// - Parameter overwrite: Overwrite existing config file.
    ///
    /// - Throws: throws if the command fails to execute
    public func initConfig(destDir: String? = nil, destFile: String? = nil, overwrite: Bool = false) throws -> Data
    {
        var args: [String] = ["init"]
        
        if let destDir = destDir {
            args.append("--dest-dir")
            args.append(destDir)
        }
        
        if let destFile = destFile {
            args.append("--dest-file")
            args.append(destFile)
        }
        
        if overwrite {
            args.append("--overwrite")
        }
        
        return try self.run(args)
    }
    
    /// Removes one or more values from a setting
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_remove/)
    ///
    /// - Throws: throws if the command fails to execute
    public func remove(flags: [String], setting: CliConfig) throws -> Data
    {
        var args: [String] = ["config", "add"]
        
        switch setting {
            case .boardManager(.additionalUrls):
                args.append("board_manager.additional_urls")
            case .daemon(.port):
                args.append("daemon.port")
            case .directories(.data):
                args.append("directories.data")
            case .directories(.downloads):
                args.append("directories.downloads")
            case .directories(.user):
                args.append("directories.user")
            case .library(.enableUnsafeInstall):
                args.append("library.enable_unsafe_install")
            case .logging(.format):
                args.append("logging.format")
            case .logging(.file):
                args.append("logging.file")
            case .logging(.level):
                args.append("logging.level")
            case .metrics(.addr):
                args.append("metrics.addr")
            case .metrics(.enable):
                args.append("metrics.enable")
            case .output(.noColor):
                args.append("output.no_color")
            case .sketch(.alwaysSupportBinaries):
                args.append("sketch.always_support_binaries")
            case .updater(.enableNotification):
                args.append("updater.enable_notification")
        }
        
        args += flags
        return try self.run(args)
    }
    
    /// Sets a setting value
    /// - seealso: [arduino-cli documentation](https://arduino.github.io/arduino-cli/0.20/commands/arduino-cli_config_set/)
    ///
    /// - Throws: throws if the command fails to execute
    public func set(flags: String, setting: CliConfig) throws -> Data
    {
        var args: [String] = ["config", "set"]
        switch setting {
            case .boardManager(.additionalUrls):
                args.append("board_manager.additional_urls")
            case .daemon(.port):
                args.append("daemon.port")
            case .directories(.data):
                args.append("directories.data")
            case .directories(.downloads):
                args.append("directories.downloads")
            case .directories(.user):
                args.append("directories.user")
            case .library(.enableUnsafeInstall):
                args.append("library.enable_unsafe_install")
            case .logging(.format):
                args.append("logging.format")
            case .logging(.file):
                args.append("logging.file")
            case .logging(.level):
                args.append("logging.level")
            case .metrics(.addr):
                args.append("metrics.addr")
            case .metrics(.enable):
                args.append("metrics.enable")
            case .output(.noColor):
                args.append("output.no_color")
            case .sketch(.alwaysSupportBinaries):
                args.append("sketch.always_support_binaries")
            case .updater(.enableNotification):
                args.append("updater.enable_notification")
        }
        
        args.append(flags)
        return try self.run(args)
    }
    
    public enum CliConfig {
        case boardManager(BoardManager)
        case daemon(Daemon)
        case directories(Directories)
        case library(Library)
        case logging(Logging)
        case metrics(Metrics)
        case output(Output)
        case sketch(Sketch)
        case updater(Updater)
        
        public enum BoardManager {
            case additionalUrls
        }
        
        public enum Daemon {
            case port
        }
        
        public enum Directories {
            case data
            case downloads
            case user
        }
        
        public enum Library {
            case enableUnsafeInstall
        }
        
        public enum Logging {
            case file
            case format
            case level
        }
        
        public enum Metrics {
            case addr
            case enable
        }
        
        public enum Output {
            case noColor
        }
        
        public enum Sketch {
            case alwaysSupportBinaries
        }
        
        public enum Updater {
            case enableNotification
        }
    }
}

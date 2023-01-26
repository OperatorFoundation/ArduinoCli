//
//  File.swift
//  
//
//  Created by Joshua Clark on 11/21/22.
//

import Foundation

public struct ArduinoCliConfigFile: Codable {
    var boardManager: BoardManager
    var daemon: Daemon
    var directories: Directories
    var library: Library
    var logging: Logging
    var metrics: Metrics
    var output: Output
    var sketch: Sketch
    var updater: Updater
    
    enum CodingKeys: String, CodingKey
    {
        case boardManager = "board_manager"
        case daemon = "daemon"
        case directories = "directories"
        case library = "library"
        case logging = "logging"
        case metrics = "metrics"
        case output = "output"
        case sketch = "sketch"
        case updater = "updater"
        
    }
}

public struct BoardManager: Codable {
    var additionalUrls: [String]
    
    enum CodingKeys: String, CodingKey
    {
        case additionalUrls = "additional_urls"
    }
}

public struct Daemon: Codable {
    var port: String
}

public struct Directories: Codable {
    var data: String
    var downloads: String
    var user: String
}

public struct Library: Codable {
    var enableUnsafeInstall: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case enableUnsafeInstall = "enable_unsafe_install"
    }
}

public struct Logging: Codable {
    var file: String
    var format: String
    var level: String
}

public struct Metrics: Codable {
    var addr: String
    var enabled: Bool
}

public struct Output: Codable {
    var noColor: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case noColor = "no_color"
    }
}

public struct Sketch: Codable {
    var alwaysExportBinaries: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case alwaysExportBinaries = "always_export_binaries"
    }
}

public struct Updater: Codable {
    var enableNotification: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case enableNotification = "enable_notification"
    }
}

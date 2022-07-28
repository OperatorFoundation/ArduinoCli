import Foundation

import Gardener
import Transmission

public class ArduinoCli
{
    static public let instance = ArduinoCli()
    static let arduinoDaemonPort = 50051

    var daemon: Task<Void,Error>? = nil

    public var isRunning: Bool
    {
        if let connection = TransmissionConnection(host: "127.0.0.1", port: ArduinoCli.arduinoDaemonPort)
        {
            connection.close()
            return true
        }
        else
        {
            return false
        }
    }

    init?()
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

        if !isRunning
        {
            self.launch()
        }
    }

    public func stop()
    {
        if let daemon = self.daemon
        {
            if !daemon.isCancelled
            {
                daemon.cancel()
            }
        }
    }

    func launch()
    {
        Command.addDefaultPath("/opt/homebrew/bin")
        let command = Command()

        self.daemon = Task
        {
            guard let _ = command.run("arduino-cli", "daemon") else
            {
                throw ArduinoCliError.daemonFailed
            }
        }
    }
}

public enum ArduinoCliError: Error
{
    case daemonFailed
}

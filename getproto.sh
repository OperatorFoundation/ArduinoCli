brew install swift-protobuf
brew install grpc-swift
wget -O Resources/commands.proto https://raw.githubusercontent.com/arduino/arduino-cli/master/rpc/cc/arduino/cli/commands/v1/commands.proto
./protoc.sh ../arduino-cli/rpc

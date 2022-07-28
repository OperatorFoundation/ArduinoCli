protoc $1/cc/arduino/cli/commands/v1/commands.proto --proto_path=$1 --plugin=/opt/homebrew/bin/protoc-gen-swift --swift_opt=Visibility=Public --swift_out=Sources/ArduinoCli/GRPC
protoc $1/cc/arduino/cli/commands/v1/commands.proto --proto_path=$1 --plugin=/opt/homebrew/bin/protoc-gen-grpc-swift --swift_opt=Visibility=Public --swift_out=Sources/ArduinoCli/GRPC

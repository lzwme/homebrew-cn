cask "socket-io-tester" do
  version "1.2.3"
  sha256 "dad65ffd41c8062d5bf5983af233307efc3257ee4c675a5e97f23f7694916e73"

  url "https://ghfast.top/https://github.com/AppSaloon/socket.io-tester/releases/download/v#{version}/socket-io-tester-darwin-x64.zip"
  name "socket-io-tester.app"
  homepage "https://github.com/AppSaloon/socket.io-tester"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "socket-io-tester-darwin-x64/socket-io-tester.app"

  caveats do
    requires_rosetta
  end
end
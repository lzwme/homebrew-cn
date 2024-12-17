cask "socket-io-tester" do
  version "1.2.3"
  sha256 "dad65ffd41c8062d5bf5983af233307efc3257ee4c675a5e97f23f7694916e73"

  url "https:github.comAppSaloonsocket.io-testerreleasesdownloadv#{version}socket-io-tester-darwin-x64.zip"
  name "socket-io-tester.app"
  homepage "https:github.comAppSaloonsocket.io-tester"

  disable! date: "2024-12-16", because: :discontinued

  app "socket-io-tester-darwin-x64socket-io-tester.app"

  caveats do
    requires_rosetta
  end
end
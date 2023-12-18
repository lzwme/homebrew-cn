cask "openinterminal-lite" do
  version "1.2.5"
  sha256 "2d2f7ab19bcd443fa533a294875a0e95333cca0a60707ac7226bcafaaae2972b"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInTerminal-Lite.app.zip"
  name "OpenInTerminal-Lite"
  desc "Finder Toolbar app to open the current directory in Terminal"
  homepage "https:github.comJi4n1ngOpenInTerminal"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "OpenInTerminal-Lite.app"

  zap trash: "~LibraryPreferenceswang.jianing.app.OpenInTerminal-Lite.plist"
end
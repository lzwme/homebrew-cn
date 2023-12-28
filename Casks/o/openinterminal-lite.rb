cask "openinterminal-lite" do
  version "1.2.6"
  sha256 "52a29ef900997262bc1e4a1e4e5da83d67ee332f1b35c596e79f031fd9d10a2b"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInTerminal-Lite.zip"
  name "OpenInTerminal-Lite"
  desc "Finder Toolbar app to open the current directory in Terminal"
  homepage "https:github.comJi4n1ngOpenInTerminal"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "OpenInTerminal-Lite.app"

  zap trash: "~LibraryPreferenceswang.jianing.app.OpenInTerminal-Lite.plist"
end
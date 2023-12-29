cask "openinterminal-lite" do
  version "1.2.6"
  sha256 "8eaaf3052f704a4a6c7795227611f4a406ac80c60a37e936ff8ce19ca6f53e86"

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
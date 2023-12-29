cask "openineditor-lite" do
  version "1.2.6"
  sha256 "d8f9c20b685cfa2b8fe8917ef12986d394712dfc3ba3e421bcd6f394fa1b3206"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInEditor-Lite.zip"
  name "OpenInEditor-Lite"
  desc "Finder Toolbar app to open the current directory in Editor"
  homepage "https:github.comJi4n1ngOpenInTerminal"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "OpenInEditor-Lite.app"

  zap trash: "~LibraryPreferenceswang.jianing.app.OpenInEditor-Lite.plist"
end
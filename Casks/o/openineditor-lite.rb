cask "openineditor-lite" do
  version "1.2.5"
  sha256 "745f81ba178795d44e97c8c60b8b28022f7258f70f673555da0da3a34637519d"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInEditor-Lite.app.zip"
  name "OpenInEditor-Lite"
  desc "Finder Toolbar app to open the current directory in Editor"
  homepage "https:github.comJi4n1ngOpenInTerminal"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "OpenInEditor-Lite.app"

  zap trash: "~LibraryPreferenceswang.jianing.app.OpenInEditor-Lite.plist"
end
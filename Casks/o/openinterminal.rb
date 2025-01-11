cask "openinterminal" do
  version "2.3.8"
  sha256 "da9eeb6cdd5db3de963e6f6a49d9d3cbff11f72cd3d56eeb6a657c88fae0aa6f"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInTerminal.zip"
  name "OpenInTerminal"
  desc "Finder Toolbar app to open the current directory in Terminal or Editor"
  homepage "https:github.comJi4n1ngOpenInTerminal"

  depends_on macos: ">= :sierra"

  app "OpenInTerminal.app"

  zap trash: [
    "~LibraryApplication Scriptsgroup.wang.jianing.app.OpenInTerminal",
    "~LibraryApplication Scriptswang.jianing.app.OpenInTerminal",
    "~LibraryApplication Scriptswang.jianing.app.OpenInTerminal.OpenInTerminalFinderExtension",
    "~LibraryApplication Scriptswang.jianing.app.OpenInTerminalHelper",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentswang.jianing.app.openinterminalhelper.sfl*",
    "~LibraryContainerswang.jianing.app.OpenInTerminal.OpenInTerminalFinderExtension",
    "~LibraryContainerswang.jianing.app.OpenInTerminalHelper",
    "~LibraryGroup Containersgroup.wang.jianing.app.OpenInTerminal",
    "~LibraryLogsOpenInTerminal",
    "~LibraryPreferenceswang.jianing.app.OpenInTerminal.plist",
  ]
end
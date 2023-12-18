cask "openinterminal" do
  version "2.3.6"
  sha256 "11af1d2367e966dc4ea829cbf39cc7c869af50d687708600b188024539180ec8"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInTerminal.app.zip"
  name "OpenInTerminal"
  desc "Finder Toolbar app to open the current directory in Terminal or Editor"
  homepage "https:github.comJi4n1ngOpenInTerminal"

  depends_on macos: ">= :sierra"

  app "OpenInTerminal.app"

  zap trash: [
    "~LibraryApplication Scriptswang.jianing.app.OpenInTerminal",
    "~LibraryApplication Scriptswang.jianing.app.OpenInTerminal.OpenInTerminalFinderExtension",
    "~LibraryApplication Scriptswang.jianing.app.OpenInTerminalHelper",
    "~LibraryContainerswang.jianing.app.OpenInTerminal.OpenInTerminalFinderExtension",
    "~LibraryContainerswang.jianing.app.OpenInTerminalHelper",
    "~LibraryGroup Containersgroup.wang.jianing.app.OpenInTerminal",
    "~LibraryLogsOpenInTerminal",
  ]
end
cask "openinterminal" do
  version "2.3.7"
  sha256 "ef864967b3ba118ec4caf5a0e1e571ac88fb350678862653a3732ed6e5f2faec"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInTerminal.zip"
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
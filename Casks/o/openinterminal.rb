cask "openinterminal" do
  version "2.3.7"
  sha256 "1b8453c8e10345d9e74b395e15115c870b42b2d055c28f50f9844908e7b690d3"

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
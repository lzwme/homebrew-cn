cask "lapce" do
  version "0.4.1"
  sha256 "587ad625fe24ca0b3eb1bc1761748af3be126cff346415966d4efa8adfd9e8ec"

  url "https:github.comlapcelapcereleasesdownloadv#{version}Lapce-macos.dmg",
      verified: "github.comlapcelapce"
  name "Lapce"
  desc "Open source code editor written in Rust"
  homepage "https:lapce.dev"

  app "Lapce.app"
  binary "#{appdir}Lapce.appContentsMacOSlapce"

  uninstall quit: "io.lapce"

  zap trash: [
    "~.lapce",
    "~LibraryApplication Supportdev.lapce.Lapce-Stable",
    "~LibraryApplication SupportLapce",
    "~LibrarySaved Application Stateio.lapce.savedState",
  ]
end
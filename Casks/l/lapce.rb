cask "lapce" do
  version "0.4.0"
  sha256 "2db2e91891abcd2a485c0677017bfcc4cceaf599be1427961d6f597072f6b9ac"

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
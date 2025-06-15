cask "lapce" do
  version "0.4.2"
  sha256 "6df0b260d80d00e88155ee669509bc61afab1d2490c846f70d1d537952b1a011"

  url "https:github.comlapcelapcereleasesdownloadv#{version}Lapce-macos.dmg",
      verified: "github.comlapcelapce"
  name "Lapce"
  desc "Open source code editor written in Rust"
  homepage "https:lapce.dev"

  no_autobump! because: :requires_manual_review

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
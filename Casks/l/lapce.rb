cask "lapce" do
  version "0.4.3"
  sha256 "f4eb6fd004dc85b8aed667663e559265d7c2a9967f1b818c6f1c325b1186c2ce"

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
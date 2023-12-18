cask "lapce" do
  version "0.3.1"
  sha256 "a84edcbd27b339c21bae68695dd9c14fa057c824ad8c2b26f6c32c3d126fdac7"

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
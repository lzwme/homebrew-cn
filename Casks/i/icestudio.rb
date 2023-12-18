cask "icestudio" do
  version "0.11"
  sha256 "959f55093888b91fa8b6715ecc9d6a4d2494dc814ee2ab717ee825284ba13889"

  url "https:github.comFPGAwarsicestudioreleasesdownloadv#{version}icestudio-#{version}-osx64.dmg",
      verified: "github.comFPGAwarsicestudio"
  name "icestudio"
  desc "Visual editor for open FPGA board"
  homepage "https:icestudio.io"

  app "icestudio.app"

  zap trash: [
    "~.icestudio",
    "~icestudio.log",
    "~LibraryApplication Supporticestudio",
    "~LibraryCachesicestudio",
    "~LibraryPreferencescom.nw-builder.icestudio.plist",
    "~LibrarySaved Application Statecom.nw-builder.icestudio.savedState",
  ]
end
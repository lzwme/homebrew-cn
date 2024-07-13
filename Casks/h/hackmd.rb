cask "hackmd" do
  version "0.1.0"
  sha256 "681051aa8a89ce2f3a0b2c374fa8d3d6dbf43be7464307749ff029df7c4eed7a"

  url "https:github.comhackmdiohackmd-desktopreleasesdownloadv#{version}HackMD-#{version}.dmg"
  name "HackMD"
  desc "Desktop Software for HackMD Note-Taking and Collaboration"
  homepage "https:github.comhackmdiohackmd-desktop"

  app "HackMD.app"

  zap trash: [
    "~LibraryApplication SupportHackMD",
    "~LibrarySaved Application Statecom.hackmd.desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
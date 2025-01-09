cask "serial-studio" do
  arch arm: "arm64", intel: "x86_64"

  version "3.0.6"
  sha256 arm:   "86c36cd424ac22e0c01b6f02f4f94f99d27d96f9f5ced3da2ef6e303a64ef282",
         intel: "00cf58d347c5bc71f89895df0a191543e65e32a79ce6847e466e67061399c576"

  url "https:github.comSerial-StudioSerial-Studioreleasesdownloadv#{version}Serial-Studio-#{version}-macOS-#{arch}.dmg",
      verified: "github.comSerial-StudioSerial-Studio"
  name "Serial Studio"
  desc "Data visualisation software for embedded devices and projects"
  homepage "https:serial-studio.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Serial Studio.app"

  zap trash: [
    "~LibraryCachesAlex SpataruSerial-Studio",
    "~LibraryPreferencesio.github.serial-studio.Serial-Studio.plist",
    "~LibrarySaved Application Stateorg.alexspataru.serial-studio.savedState",
  ]
end
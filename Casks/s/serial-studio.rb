cask "serial-studio" do
  version "3.1.4"
  sha256 "0bf75d052cb71eb9960b09f5b406899edcecda1cd30a1edb7ff0b98a3a211e98"

  url "https:github.comSerial-StudioSerial-Studioreleasesdownloadv#{version}Serial-Studio-#{version}-macOS-Universal.dmg",
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
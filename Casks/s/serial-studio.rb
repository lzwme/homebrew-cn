cask "serial-studio" do
  version "3.1.1"
  sha256 "143c3f3708e33df5b238b442a78692464db0c3a5d7c74d753cebf443742b9354"

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
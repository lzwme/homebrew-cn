cask "serial-studio" do
  version "3.1.7"
  sha256 "a005d0d44c7424bccdea17cfec7e11e33c11e5884fe84ac05122d35ac4a9834e"

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
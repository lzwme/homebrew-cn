cask "serial-studio" do
  version "3.1.5"
  sha256 "560c7c97246df67ddc1242ce1c224517560547393948c93c4d33079b3d232e69"

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
cask "inav-configurator" do
  version "7.1.1"
  sha256 "9cbd1e741d97658a46c1ed37c372b9935737ffb987c80d7fdc47dbf46794379c"

  url "https:github.comiNavFlightinav-configuratorreleasesdownload#{version}INAV-Configurator_macOS_#{version}.zip"
  name "INAV Configurator"
  desc "Configuration tool for the INAV flight control system"
  homepage "https:github.comiNavFlightinav-configurator"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "INAV Configurator.app"

  zap trash: [
    "~LibraryApplication Supportinav-configurator",
    "~LibraryCachesinav-configurator",
    "~LibraryPreferencescom.nw-builder.inav-configurator.plist",
    "~LibrarySaved Application Statecom.nw-builder.inav-configurator.savedState",
  ]
end
cask "inav-configurator" do
  version "7.0.1"
  sha256 "146ecf0ec53574caf9e97120fd04efd47496ec3b3e7f4e3e0656e267ae4adf70"

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
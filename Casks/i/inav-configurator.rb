cask "inav-configurator" do
  version "7.0.0"
  sha256 "99efb8ece11bb680075e70b6f34d85750f2aa7d4735d46a61e2c98434618826d"

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
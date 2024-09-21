cask "inav-configurator" do
  version "7.1.2"
  sha256 "afc1b988549f48e81839e900b3a46380a213b5e943fe0c27dfd2659047553891"

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

  caveats do
    requires_rosetta
  end
end
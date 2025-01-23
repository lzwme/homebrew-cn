cask "inav-configurator" do
  arch arm: "arm64", intel: "x64"

  version "8.0.0"
  sha256 arm:   "7967c017eb21b2f6ae3b582a9d3b31b15652b670b0217f01fed3946b9775aeb7",
         intel: "497a59fbc3117b99841158ec081e3f656eaa70039765942ddfe3cc464d5375dd"

  url "https:github.comiNavFlightinav-configuratorreleasesdownload#{version}INAV-Configurator_darwin_#{arch}_#{version}.zip"
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
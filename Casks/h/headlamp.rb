cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.23.0"
  sha256 arm:   "d42f31ccb98d6c4e3db630b54fe79a595f8dc2c7fff7268b7cee0ec8b0e5824f",
         intel: "a53a27f822dc525b06b14d0d3e029189adcefe0c0fc3c711120cccbb25efbf4c"

  url "https:github.comkinvolkheadlampreleasesdownloadv#{version}Headlamp-#{version}-mac-#{arch}.dmg",
      verified: "github.comkinvolkheadlamp"
  name "Headlamp"
  desc "UI for Kubernetes"
  homepage "https:kinvolk.github.ioheadlamp"

  app "Headlamp.app"

  uninstall quit: "com.kinvolk.headlamp"

  zap trash: [
    "~LibraryApplication SupportHeadlamp",
    "~LibraryLogsHeadlamp",
    "~LibraryPreferencescom.kinvolk.headlamp.plist",
  ]
end
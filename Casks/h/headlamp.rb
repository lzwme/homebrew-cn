cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.23.2"
  sha256 arm:   "544ab8c1d692fe58f8cf7cba7f4a68920a3c25bf86b36aca52d2dc7cd2068463",
         intel: "4e21427d88d895fb42a181aca1052d2d6a24a4099953e660d5360ab925f6de52"

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
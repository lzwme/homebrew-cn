cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.23.1"
  sha256 arm:   "d488c8d0e07110f56df1a16f84a3cfac97219a4ce7167525bada2682c4b30d4a",
         intel: "042fded279cd2c7d7fd90c4007327d62c8e6d7ff693c9998cd352c0c6a706973"

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
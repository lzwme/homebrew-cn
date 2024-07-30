cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.25.0"
  sha256 arm:   "ea0ddeb12f7b3b32346f438586324c25583f9bc127128660f972fbc4823cdcba",
         intel: "a091c9f833b030f1cd7cf99873d7e670581a772e9737bec7f78b77db5ddb2409"

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
cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.24.1"
  sha256 arm:   "6f7cb329966228393053c025a7bfbd0cc6d11a37aa0d12831773eaef050e3cfc",
         intel: "fc8bc2ebf051ac63f36c0a4c5f85da3e7213c4158e070d776ee5774f0f77a36f"

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
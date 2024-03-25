cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.6"
  sha256 arm:   "7330070a3d54ca24aa0d59f336ecef2483620ffd2a236e3abb6270dd37ea5cd5",
         intel: "beb5bff073c1807e971e9b29e58d5b5a16243249d1f523c2fbef27a838fa4c1f"

  url "https:github.comspacedriveappspacedrivereleasesdownload#{version}Spacedrive-darwin-#{arch}.dmg"
  name "Spacedrive"
  desc "Open source cross-platform file explorer"
  homepage "https:github.comspacedriveappspacedrive"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Spacedrive.app"

  zap trash: [
    "~LibraryApplication Supportspacedrive",
    "~LibraryCachescom.spacedrive.desktop",
    "~LibraryPreferencescom.spacedrive.desktop.plist",
    "~LibrarySaved Application Statecom.spacedrive.desktop.savedState",
    "~LibraryWebKitcom.spacedrive.desktop",
  ]
end
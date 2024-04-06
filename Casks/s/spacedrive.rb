cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.11"
  sha256 arm:   "f6e07138558c99256cdea7ec2e3660e5f2fad3802fbf495b0526dedfc75e6ff6",
         intel: "2b7692633d60f0b9a9d59190caeb8f2c9fe4506be48735d672618145bbccaa28"

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
cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.2"
  sha256 arm:   "74cc7d31a1d39da1292b58bb1b09c218836c30a53fafd67cc548bb7d6b2925c5",
         intel: "5a3fe2fe94426584cded00ff1d750499ea562d122496da9908d65a5847da7f70"

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
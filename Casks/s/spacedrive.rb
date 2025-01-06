cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.4.2"
  sha256 arm:   "5b49c5366060af2a538f563aafabecb5d2f451468ff634ce1f9460022af0c6c6",
         intel: "897eda52cda4d5f8cea03c648176de3c461760a14adeb18594df5bd3e833dfbf"

  url "https:github.comspacedriveappspacedrivereleasesdownload#{version}Spacedrive-darwin-#{arch}.dmg"
  name "Spacedrive"
  desc "Open source cross-platform file explorer"
  homepage "https:github.comspacedriveappspacedrive"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Spacedrive.app"

  zap trash: [
    "~LibraryApplication Supportspacedrive",
    "~LibraryCachescom.spacedrive.desktop",
    "~LibraryPreferencescom.spacedrive.desktop.plist",
    "~LibrarySaved Application Statecom.spacedrive.desktop.savedState",
    "~LibraryWebKitcom.spacedrive.desktop",
  ]
end
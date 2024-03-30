cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.9"
  sha256 arm:   "d45752b71eff607cd7ab7f1fdb78c473de7e7de8b66e2c4970d822a862fe5832",
         intel: "3b83debe5e073cdb0c75cbf6da4723dd8bd00fe1623a2ae23d231c11bcaf91bb"

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
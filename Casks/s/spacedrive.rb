cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.7"
  sha256 arm:   "a8d69b0492f03c7667d24bbbdec56dfbc392994cd1b74d949ad6416242f06086",
         intel: "ef803661c003a60b1e8ae92b69ab827f7d851782b994d9cc6fa7e4cba955de21"

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
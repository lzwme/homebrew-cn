cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.4.3"
  sha256 arm:   "d018fa1a3b312d480b972700df7a5722f22da2a16d6ad8c997667f6708e70b47",
         intel: "1355c219e5817bfa071c4de2cccca44fcc05ac81a134cbe6c4489e32b9d27d9f"

  url "https:github.comspacedriveappspacedrivereleasesdownload#{version}Spacedrive-darwin-#{arch}.dmg"
  name "Spacedrive"
  desc "Open source cross-platform file explorer"
  homepage "https:github.comspacedriveappspacedrive"

  livecheck do
    url "https:www.spacedrive.comapireleases"
    strategy :json do |json|
      json.map { |item| item["version"] }
    end
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
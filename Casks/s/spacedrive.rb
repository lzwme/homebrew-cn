cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.0"
  sha256 arm:   "e06f0bede0d21c1bb4a074eb8617312a91fb7ae3cf9686dec2f30806abd2a278",
         intel: "e85b952aa32c90e07fb06ecc1fa229c733845579f84cf252f31070925277a910"

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
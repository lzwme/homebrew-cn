cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.8"
  sha256 arm:   "0b2ea7144af490143cc872ce0403d23d87e1d33463edb0bf0f8aa64193da0711",
         intel: "4d4407d05d9fb9d007f33a1cc135edaf7b188de3265df0b4a5dcb3008e4bbf71"

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
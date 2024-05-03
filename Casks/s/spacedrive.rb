cask "spacedrive" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.14"
  sha256 arm:   "1b4132edec197977a08aa9005c5992d0c75a625953a61a7b06eaace7fe3f9966",
         intel: "ca95036fde11946a897e47f886d58a67452b199d12c8266bac0aad32ec43cc32"

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
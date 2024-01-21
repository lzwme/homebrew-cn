cask "timche-gmail-desktop" do
  version "2.25.3"
  sha256 "8c5a8c4e651d7c328f3e7947e2b1ccc437245840ef33ea3d3f4b45fe7b82dc2e"

  url "https:github.comtimchegmail-desktopreleasesdownloadv#{version}gmail-desktop-#{version}-mac.dmg"
  name "Gmail Desktop"
  desc "Unofficial Gmail desktop app"
  homepage "https:github.comtimchegmail-desktop"

  app "Gmail Desktop.app"

  zap trash: [
    "~LibraryApplication SupportGmail Desktop",
    "~LibraryCachesio.cheung.gmail-desktop",
    "~LibraryCachesio.cheung.gmail-desktop.ShipIt",
    "~LibraryLogsGmail Desktop",
    "~LibraryPreferencesio.cheung.gmail-desktop.plist",
    "~LibrarySaved Application Stateio.cheung.gmail-desktop.savedState",
    "~LibraryWebKitio.cheung.gmail-desktop",
  ]
end
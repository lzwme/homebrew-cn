cask "element" do
  version "1.11.64"
  sha256 :no_check

  url "https:packages.element.iodesktopinstallmacosElement.dmg"
  name "Element"
  desc "Matrix collaboration client"
  homepage "https:element.ioget-started"

  # The upstream website doesn't appear to provide version information. We check
  # GitHub releases as a best guess of when a new version is released.
  livecheck do
    url "https:github.comvector-imelement-desktop"
    strategy :github_latest
  end

  auto_updates true

  app "Element.app"

  zap trash: [
    "~LibraryApplication SupportElement",
    "~LibraryApplication SupportRiot",
    "~LibraryCachesim.riot.app",
    "~LibraryCachesim.riot.app.ShipIt",
    "~LibraryLogsRiot",
    "~LibraryPreferencesim.riot.app.helper.plist",
    "~LibraryPreferencesim.riot.app.plist",
    "~LibrarySaved Application Stateim.riot.app.savedState",
  ]
end
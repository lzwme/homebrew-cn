cask "raindropio" do
  arch arm: "arm64", intel: "x64"

  version "5.6.56"
  sha256 arm:   "764157e89c3332995285ba2d6dc78ba5495a8e5abe14d34924f09db480659d2f",
         intel: "dacd699e0f0b236e09ccead67ccde2a773fd36d8042d9d99c59ddc7c4d860706"

  url "https:github.comraindropiodesktopreleasesdownloadv#{version}Raindrop-#{arch}.dmg",
      verified: "github.comraindropiodesktop"
  name "Raindrop.io"
  desc "All-in-one bookmark manager"
  homepage "https:raindrop.io"

  # First-party download page links to dmg file from GitHub "latest" release.
  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Raindrop.io.app"

  zap trash: [
    "~LibraryApplication SupportRaindrop.io",
    "~LibraryCachescom.apple.SafariExtensionsRaindrop.io.safariextension",
    "~LibraryCookiesio.raindrop.mac.binarycookies",
    "~LibraryPreferencesio.raindrop.mac.helper.plist",
    "~LibraryPreferencesio.raindrop.mac.plist",
    "~LibrarySafariExtensionsRaindrop.io.safariextz",
    "~LibrarySaved Application Stateio.raindrop.mac.savedState",
  ]
end
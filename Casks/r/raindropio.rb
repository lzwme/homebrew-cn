cask "raindropio" do
  arch arm: "arm64", intel: "x64"

  version "5.6.5"
  sha256 arm:   "179162e2c8d9920af7cc6011119a9259b040f58e0620a58977d488eebba0d4db",
         intel: "ee47adebfab8ebeced793b1a83098664e98f00c04819fd19372f5cd49e8ddf8e"

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
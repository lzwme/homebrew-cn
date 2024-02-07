cask "raindropio" do
  arch arm: "arm64", intel: "x64"

  version "5.6.19"
  sha256 arm:   "532ea8fbf7159acc3d4307b3972d49d7286503442efa0a9cf9d28ab110b0e163",
         intel: "be5e7653823ecf45753f086936189e8d7e27d74c00ba0c2e3dd14003d4bb22a3"

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
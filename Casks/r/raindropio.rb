cask "raindropio" do
  arch arm: "arm64", intel: "x64"

  version "5.6.35"
  sha256 arm:   "96e2eed0d37a6c8869a08f83f730b446a75e8d8f153164e5461919b4e0fd9cba",
         intel: "ce1226ac9932455a0f5f69e4e25cf78830921df69a052b8ee698e54c5a3ba021"

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
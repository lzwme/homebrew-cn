cask "raindropio" do
  arch arm: "arm64", intel: "x64"

  version "5.6.38"
  sha256 arm:   "e32cc29e33501f47b269286572215a767fd79e14c1a575f2e35717db0b456e62",
         intel: "0ac02821bb4cbd892fba16ca24f109273588160eef8061c8394558e5e269544b"

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
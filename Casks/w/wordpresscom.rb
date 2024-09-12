cask "wordpresscom" do
  arch arm: "arm64", intel: "x64"

  version "8.0.4"
  sha256 arm:   "4fea40eba336ad397a0c55f511a7942c6314970d9daa57fedb609ff487887a21",
         intel: "8f76a13f4b2f152b20220d196af8b60236d475d65a5689849efd9e0f50a308b2"

  url "https:github.comAutomatticwp-desktopreleasesdownloadv#{version}wordpress.com-macOS-dmg-#{version}-#{arch}.dmg",
      verified: "github.comAutomatticwp-desktop"
  name "WordPress.com"
  desc "WordPress client"
  homepage "https:apps.wordpress.comdesktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "WordPress.com.app"

  uninstall quit: "com.automattic.wordpress"

  zap trash: [
    "~LibraryApplication SupportCacheswordpressdesktop-updater",
    "~LibraryApplication SupportWordpress.com",
    "~LibraryCachescom.automattic.wordpress",
    "~LibraryCachescom.automattic.wordpress.ShipIt",
    "~LibraryHTTPStoragescom.automattic.wordpress",
    "~LibraryPreferencesByHostcom.automattic.wordpress.ShipIt.*.plist",
    "~LibraryPreferencescom.automattic.wordpress*.plist",
    "~LibrarySaved Application Statecom.automattic.wordpress.savedState",
  ]
end
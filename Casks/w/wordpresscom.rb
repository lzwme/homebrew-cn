cask "wordpresscom" do
  arch arm: "arm64", intel: "x64"

  version "8.0.3"
  sha256 arm:   "fa918e3df870deafe299b11a16b3753f6fb8a1af36b0c616620c1c1b98e20ec8",
         intel: "98f54a7559b57146dc3689c83609d82f0c57fa0f2576d5a84b38b18ea1e2bec7"

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
cask "kap" do
  arch arm: "arm64", intel: "x64"

  version "3.6.0"
  sha256 arm:   "0f4b69d5fd4ec59da7b6e153722314c93dc263db2b81c0d0191e256360473ce3",
         intel: "8086dd10963177b878bdc709081e4efbbc713baeacb64d962bcd081bd0bf780f"

  url "https:github.comwulkanokapreleasesdownloadv#{version.major_minor_patch}Kap-#{version}-#{arch}.dmg",
      verified: "github.comwulkanokap"
  name "Kap"
  desc "Open-source screen recorder built with web technology"
  homepage "https:getkap.co"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Kap.app"

  zap trash: [
    "~LibraryApplication SupportKap",
    "~LibraryCachescom.wulkano.kap",
    "~LibraryCachescom.wulkano.kap.ShipIt",
    "~LibraryCookiescom.wulkano.kap.binarycookies",
    "~LibraryPreferencescom.wulkano.kap.helper.plist",
    "~LibraryPreferencescom.wulkano.kap.plist",
    "~LibrarySaved Application Statecom.wulkano.kap.savedState",
  ]
end
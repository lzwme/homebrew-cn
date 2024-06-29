cask "insomnia" do
  version "9.3.1"
  sha256 "a79512ac8f01ac4414bc5f3fe3430f5687c8d9ea2848852c51c9e7ea784de047"

  url "https:github.comKonginsomniareleasesdownloadcore%40#{version}Insomnia.Core-#{version}.dmg",
      verified: "github.comKonginsomnia"
  name "Insomnia"
  desc "HTTP and GraphQL Client"
  homepage "https:insomnia.rest"

  # Upstream previously used a date-based version scheme (e.g., `2023.5.8`)
  # before switching to a typical `8.1.0` format. The date-based versions are
  # numerically higher, so we have to avoid matching them.
  livecheck do
    url :url
    regex(^core@v?(\d{1,3}(?:\.\d+)+)$i)
  end

  auto_updates true
  conflicts_with cask: "insomnia@alpha"
  depends_on macos: ">= :catalina"

  app "Insomnia.app"

  zap trash: [
    "~LibraryApplication SupportInsomnia",
    "~LibraryCachescom.insomnia.app",
    "~LibraryCachescom.insomnia.app.ShipIt",
    "~LibraryCookiescom.insomnia.app.binarycookies",
    "~LibraryPreferencesByHostcom.insomnia.app.ShipIt.*.plist",
    "~LibraryPreferencescom.insomnia.app.helper.plist",
    "~LibraryPreferencescom.insomnia.app.plist",
    "~LibrarySaved Application Statecom.insomnia.app.savedState",
  ]
end
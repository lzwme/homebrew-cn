cask "mmex" do
  version "1.7.0"
  sha256 "441c2443c80a7739ce8cc56eaa2b21bb8d38f4a8c375503de5776ad7cf437441"

  url "https:github.commoneymanagerexmoneymanagerexreleasesdownloadv#{version}mmex-#{version}-Darwin.dmg",
      verified: "github.commoneymanagerexmoneymanagerex"
  name "Money Manager Ex"
  desc "Money management application"
  homepage "https:moneymanagerex.org"

  app "MMEX.app"

  zap trash: [
    "~LibraryApplication SupportMoneyManagerEx",
    "~LibraryCachesorg.moneymanagerex.mmex",
    "~LibraryPreferencesorg.moneymanagerex.mmex.plist",
    "~LibrarySaved Application Stateorg.moneymanagerex.mmex.savedState",
    "~LibraryWebKitorg.moneymanagerex.mmex",
  ]
end
cask "mmex" do
  version "1.9.0"
  sha256 "a83d1dd687f154ea1dbca8e4a716946dc008c2e9f07b3a3246ce7642ed0abb84"

  url "https:github.commoneymanagerexmoneymanagerexreleasesdownloadv#{version}mmex-#{version}-Darwin.dmg",
      verified: "github.commoneymanagerexmoneymanagerex"
  name "Money Manager Ex"
  desc "Money management application"
  homepage "https:moneymanagerex.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "MMEX.app"

  zap trash: [
    "~LibraryApplication SupportMoneyManagerEx",
    "~LibraryCachesorg.moneymanagerex.mmex",
    "~LibraryPreferencesorg.moneymanagerex.mmex.plist",
    "~LibrarySaved Application Stateorg.moneymanagerex.mmex.savedState",
    "~LibraryWebKitorg.moneymanagerex.mmex",
  ]
end
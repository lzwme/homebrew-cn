cask "mmex" do
  version "1.8.0"
  sha256 "d8e7e7ec61abf21dff7f1b2d11fdde4ad2ffddc34a01be139922e0a672d9b6f9"

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
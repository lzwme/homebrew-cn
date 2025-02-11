cask "mmex" do
  version "1.9.0"
  sha256 "49542aaa6eefb9ea079df68082c8aef8156710bcf8eb6316cadc34a15f03146a"

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
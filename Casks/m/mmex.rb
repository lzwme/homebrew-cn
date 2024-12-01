cask "mmex" do
  version "1.8.1"
  sha256 "fb59784f453290e7182a649e37fea1fa6b88f788f93e09e7f12ae756a7545dae"

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
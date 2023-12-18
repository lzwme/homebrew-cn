cask "electrum-grs" do
  version "4.4.4"
  sha256 "d3f912d12b6468bdebcd63353d785cabd5efe19a36627439fac05f67e0fe37f9"

  url "https:github.comgroestlcoinelectrum-grsreleasesdownloadv#{version}electrum-grs-#{version}.dmg",
      verified: "github.comgroestlcoinelectrum-grs"
  name "Electrum-GRS"
  desc "Groestlcoin thin client"
  homepage "https:www.groestlcoin.orggroestlcoin-electrum-wallet"

  depends_on macos: ">= :high_sierra"

  app "Electrum-GRS.app"

  zap trash: [
    "~.electrum-grs",
    "~LibraryPreferencesElectrum-GRS.plist",
    "~LibraryPreferencesorg.org.pythonmac.unspecified.Electrum-GRS.plist",
    "~LibrarySaved Application StateElectrum-GRS.savedState",
  ]
end
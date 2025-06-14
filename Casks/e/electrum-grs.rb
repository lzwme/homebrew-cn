cask "electrum-grs" do
  version "4.5.4"
  sha256 "87fd71fe9cf8e2f185664778fd0106056c34a5c545d40b50322b91c705702cd1"

  url "https:github.comgroestlcoinelectrum-grsreleasesdownloadv#{version}electrum-grs-#{version}.dmg",
      verified: "github.comgroestlcoinelectrum-grs"
  name "Electrum-GRS"
  desc "Groestlcoin thin client"
  homepage "https:www.groestlcoin.orggroestlcoin-electrum-wallet"

  livecheck do
    url "https:groestlcoin.orgversion"
    strategy :json do |json|
      json["version"]
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Electrum-GRS.app"

  zap trash: [
    "~.electrum-grs",
    "~LibraryPreferencesElectrum-GRS.plist",
    "~LibraryPreferencesorg.org.pythonmac.unspecified.Electrum-GRS.plist",
    "~LibrarySaved Application StateElectrum-GRS.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
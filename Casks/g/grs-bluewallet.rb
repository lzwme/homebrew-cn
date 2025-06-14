cask "grs-bluewallet" do
  version "6.4.5"
  sha256 "adc4cbcd4bdbaf6dce36c701fb278ae52cd72b29b10d38aaf1a5d18719016496"

  url "https:github.comGroestlcoinBlueWalletreleasesdownloadv#{version}GRS.BlueWallet.dmg",
      verified: "github.comGroestlcoinBlueWallet"
  name "GRS BlueWallet"
  desc "Groestlcoin wallet and Lightning wallet"
  homepage "https:www.groestlcoin.orggrs-bluewallet"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "GRS BlueWallet.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.groestlcoin.bluewallet123",
    "~LibraryContainersorg.groestlcoin.bluewallet123",
    "~LibraryGroup Containersgroup.org.groestlcoin.bluewallet123",
  ]
end
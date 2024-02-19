cask "bluewallet" do
  version "6.5.4"
  sha256 "79a215e2b823c07ae1697f28a71ac7a4291163f4eab8c07260c1a307b2730b0d"

  url "https:github.comBlueWalletBlueWalletreleasesdownloadv#{version}BlueWallet.#{version}.dmg",
      verified: "github.comBlueWalletBlueWallet"
  name "BlueWallet"
  desc "Bitcoin wallet and Lightning wallet"
  homepage "https:bluewallet.io"

  depends_on macos: ">= :big_sur"

  app "BlueWallet.app"

  zap trash: [
    "~LibraryApplication Scriptsio.bluewallet.bluewallet",
    "~LibraryContainersio.bluewallet.bluewallet",
    "~LibraryGroup Containersgroup.io.bluewallet.bluewallet",
  ]
end
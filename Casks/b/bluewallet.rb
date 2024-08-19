cask "bluewallet" do
  version "7.0.0"
  sha256 "bc6b50c8ec570dd77b9d0f31191db6226fe296561c208a13c1e13fda6335f018"

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
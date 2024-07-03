cask "ethereum-wallet" do
  version "0.11.1"
  sha256 "df52a7ad6519aa92d17a743d0cb3bcf3080c2c72e31b1a58fbfa4581069dc4c8"

  url "https:github.comethereummistreleasesdownloadv#{version}Ethereum-Wallet-macosx-#{version.dots_to_hyphens}.dmg"
  name "Ethereum Wallet"
  name "Mist"
  desc "Browser for Ðapps on the Ethereum network"
  homepage "https:github.comethereummist"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Ethereum Wallet.app"

  zap trash: [
    "~LibraryApplication SupportEthereum Wallet",
    "~LibraryPreferencescom.ethereum.wallet.helper.plist",
    "~LibraryPreferencescom.ethereum.wallet.plist",
  ]

  caveats do
    requires_rosetta
  end
end
cask "coin-wallet" do
  version "6.10.0"
  sha256 "12ee62712fa5e16475245e5b558eb2f327bdccb2017223f92b55faed7f99bfc0"

  url "https:github.comCoinSpaceCoinSpacereleasesdownloadv#{version}Coin.Wallet.dmg",
      verified: "github.comCoinSpaceCoinSpace"
  name "Coin Wallet"
  desc "Digital currency wallet"
  homepage "https:coin.space"

  auto_updates true

  app "Coin Wallet.app"

  zap trash: [
    "~LibraryApplication SupportCoin Wallet",
    "~LibraryCachescom.coinspace.wallet*",
    "~LibraryPreferencesByHostcom.coinspace.wallet.*.plist",
    "~LibraryPreferencescom.coinspace.wallet*.plist",
    "~LibrarySaved Application Statecom.coinspace.wallet.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
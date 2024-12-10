cask "coin-wallet" do
  version "6.6.3"
  sha256 "bb4a09ef561dbd912f16a7265a3379e1f7fa586ffa66722e86ad170bde468272"

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
cask "coin-wallet" do
  version "6.0.2"
  sha256 "56bc31e507f0aaaed0a3924ef7e003b02a619a79acf1a8231ce7600832d7b3fa"

  url "https:github.comCoinSpaceCoinSpacereleasesdownloadv#{version}Coin-Wallet.dmg",
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
end
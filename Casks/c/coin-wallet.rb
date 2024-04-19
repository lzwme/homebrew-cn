cask "coin-wallet" do
  version "6.3.0"
  sha256 "237ac12c0ab94268c8999fa88d794cf24f1ed7f8bd3453d1888b6f7ac5a25f94"

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
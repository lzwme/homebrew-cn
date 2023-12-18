cask "coin-wallet" do
  version "6.0.1"
  sha256 "c7c3b47ffb874466a09edf21c3216b2e601731ee76a6299c11ef85f51adee3a8"

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
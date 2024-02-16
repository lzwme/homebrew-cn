cask "coin-wallet" do
  version "6.1.0"
  sha256 "21f4cd4a4bd495c28341fe1b946baa0e2ed8a0c674e2f7931441a9e219d1bc94"

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
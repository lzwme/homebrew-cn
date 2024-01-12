cask "coin-wallet" do
  version "6.0.3"
  sha256 "6e6b430fcbbbd70bc1319c899882b7164411951acbfd0bf5be040403f96e2f06"

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
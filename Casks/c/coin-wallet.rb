cask "coin-wallet" do
  version "6.6.1"
  sha256 "18d0670093a54bc6e0499874a1da3ba1dbb3ee9e191c118fa4fc121a5564f9d9"

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
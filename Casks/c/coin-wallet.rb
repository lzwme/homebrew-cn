cask "coin-wallet" do
  version "6.6.0"
  sha256 "767f06ef3d78c07470ecb30ca31e15a922152942084e917df013faa4b22d2fa2"

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
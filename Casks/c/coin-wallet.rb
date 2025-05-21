cask "coin-wallet" do
  version "6.11.0"
  sha256 "0cd3460f1054fe231f28ceabf4cebf2643c7604265397a254c2c6502df61fe7b"

  url "https:github.comCoinSpaceCoinSpacereleasesdownloadv#{version}Coin.Wallet.dmg",
      verified: "github.comCoinSpaceCoinSpace"
  name "Coin Wallet"
  desc "Digital currency wallet"
  homepage "https:coin.space"

  livecheck do
    url "https:coin.spaceapiv4updatemacx64v0.0.0"
    strategy :json do |json|
      json["version"]&.sub("v", "")
    end
  end

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
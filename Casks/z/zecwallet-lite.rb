cask "zecwallet-lite" do
  version "1.8.8"
  sha256 "3ec1484a28a851bc4dfc133cfd097c1f74939a59cde34f21039f6020ffa352aa"

  url "https:github.comadityapk00zecwallet-litereleasesdownloadv#{version}Zecwallet.Lite-#{version}.dmg",
      verified: "github.comadityapk00zecwallet-lite"
  name "Zecwallet Lite"
  desc "Zcash Light Wallet"
  homepage "https:www.zecwallet.co#download"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Zecwallet Lite.app"

  zap trash: [
    "~LibraryApplication SupportZcashzecwallet-light-wallet.debug.log",
    "~LibraryApplication SupportZecwallet Lite",
  ]

  caveats do
    requires_rosetta
  end
end
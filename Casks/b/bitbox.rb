cask "bitbox" do
  version "4.47.0"
  sha256 "a937e8bb23908317e492dcd6579eff70fa3a37c08c56ea5ce9a8ac3927c886d4"

  url "https:github.comBitBoxSwissbitbox-wallet-appreleasesdownloadv#{version}BitBox-#{version}-macOS.dmg",
      verified: "github.comBitBoxSwissbitbox-wallet-appreleasesdownload"
  name "BitBox"
  desc "Protect your coins with the latest Swiss made hardware wallet"
  homepage "https:bitbox.swiss"

  livecheck do
    url "https:bitbox.swissdownload"
    regex(href=.*?BitBox[._-]v?(\d+(?:\.\d+)+)(?:[._-]macOS)?\.dmgi)
  end

  app "BitBox.app"

  zap trash: [
    "~LibraryPreferencesch.shiftcrypto.BitBoxApp.plist",
    "~LibrarySaved Application Statech.shiftcrypto.wallet.savedState",
  ]
end
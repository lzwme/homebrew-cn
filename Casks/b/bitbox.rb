cask "bitbox" do
  version "4.47.3"
  sha256 "f06caf04cb5308e1f68f43cc743cf965e1b9059723cede4bece4de12ead18847"

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
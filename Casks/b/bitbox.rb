cask "bitbox" do
  version "4.45.0"
  sha256 "588fc7d1fcade218c424eeadf8b6f41f960c475e2ac397ab8c4aa378946a95ac"

  url "https:github.comBitBoxSwissbitbox-wallet-appreleasesdownloadv#{version}BitBox-#{version}-macOS.dmg",
      verified: "github.comBitBoxSwissbitbox-wallet-appreleasesdownload"
  name "BitBox"
  desc "Protect your coins with the latest Swiss made hardware wallet"
  homepage "https:bitbox.swiss"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "BitBox.app"

  zap trash: [
    "~LibraryPreferencesch.shiftcrypto.BitBoxApp.plist",
    "~LibrarySaved Application Statech.shiftcrypto.wallet.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
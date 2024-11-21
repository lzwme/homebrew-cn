cask "bitbox" do
  version "4.46.0"
  sha256 "95faf30e2143ac720554448f4dee2bdd81227f36fb1f433591d1354aa55676f4"

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
end
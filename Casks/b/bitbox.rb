cask "bitbox" do
  version "4.42.0"
  sha256 "9be7fdd5a91061f9cce5696d839fa76f88f38b284aabdd834c2dec7c9b2fb644"

  url "https:github.comdigitalbitboxbitbox-wallet-appreleasesdownloadv#{version}BitBox-#{version}-macOS.zip",
      verified: "github.comdigitalbitboxbitbox-wallet-appreleasesdownload"
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
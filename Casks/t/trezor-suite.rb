cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "25.2.2"
  sha256 arm:   "908e1c40315f34ae38363b5c4b5c580ab136e35ac2bdff62c03650f162f7452e",
         intel: "ed0200aa61589ef16f8d2b849d287ba795874fcbed196b7895c49af4f04f66de"

  url "https:github.comtrezortrezor-suitereleasesdownloadv#{version}Trezor-Suite-#{version}-mac-#{arch}.dmg",
      verified: "github.comtrezortrezor-suite"
  name "TREZOR Suite"
  desc "Companion app for the Trezor hardware wallet"
  homepage "https:suite.trezor.io"

  livecheck do
    url "https:data.trezor.iosuitereleasesdesktoplatestlatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Trezor Suite.app"

  zap trash: [
    "~LibraryApplication Support@trezorsuite-desktop",
    "~LibraryPreferencesio.trezor.TrezorSuite.plist",
  ]
end
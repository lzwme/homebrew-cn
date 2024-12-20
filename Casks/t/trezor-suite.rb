cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.12.3"
  sha256 arm:   "4fc8bb647112ad89f3caee7ac3c0faa45721dc7043c0351c51bc95eac94400ac",
         intel: "a42f009a31eee2211a3139b9523ef8d88e4eee7c37c27631e8a38976524269f3"

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
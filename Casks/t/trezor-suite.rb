cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.8.2"
  sha256 arm:   "2b0cf05dd11e8cf8ed2408a24cc440b6473256b70b2911336078abd2d1db22b7",
         intel: "f7d90eba1d4907c70eee4ac0d1daab898ff9189e2cd3b1a96b09b0448ec57dc5"

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
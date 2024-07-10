cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.6.3"
  sha256 arm:   "31b9b8e13645b36a9b851c3c4576ce00b982feaeb81eb783937346909e3f3063",
         intel: "5d687ab98c864ced35866358ebcb9fcd86a91d3a442c8258796c79ac6826cf43"

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
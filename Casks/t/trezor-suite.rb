cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.6.1"
  sha256 arm:   "aea31b05f6faf2fe37c59616efb604e52fb371477ba7ff6a090b82208b598751",
         intel: "27ca8c5f2de465bdf04eb783b5aa76f3157c6e307254dd7957e64a387bd27ea8"

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
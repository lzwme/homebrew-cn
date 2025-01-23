cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "25.1.2"
  sha256 arm:   "cc27da74ce624680caa3728233ace15ffa82d0711178f2671e295a5afef9b04d",
         intel: "43c03437bf8ebb1d1babe4838622005b441c197c3a3fe2d8d439a24da884ec96"

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
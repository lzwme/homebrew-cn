cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.2.3"
  sha256 arm:   "6e841ced5a570281f4325f576de782bfcd96fc129315251ec20b19db59c869fe",
         intel: "49d2b693a6a26086b4bfd6de4b92d57361375259c9198f273acf635d701127d8"

  url "https:github.comtrezortrezor-suitereleasesdownloadv#{version}Trezor-Suite-#{version}-mac-#{arch}.dmg",
      verified: "github.comtrezortrezor-suite"
  name "TREZOR Suite"
  desc "Companion app for the Trezor hardware wallet"
  homepage "https:suite.trezor.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Trezor Suite.app"

  zap trash: [
    "~LibraryApplication Support@trezorsuite-desktop",
    "~LibraryPreferencesio.trezor.TrezorSuite.plist",
  ]
end
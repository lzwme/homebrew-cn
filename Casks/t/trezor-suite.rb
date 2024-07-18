cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.7.2"
  sha256 arm:   "56e5a280578d73acd0126129001e2bab50b421c4526e88acf1a6cfef02712581",
         intel: "e5f3bf719420cbd42f618db0c19f053f2484dca249030daf3739bd548ceb9a2e"

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
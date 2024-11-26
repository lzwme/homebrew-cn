cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.11.3"
  sha256 arm:   "aae11139ce1a02a76dbaaf5a34f1e8f5d7eed23931327f86dbe997405135e992",
         intel: "bd4c0fb1f170bc06b9e07b62403205b4fdd2090c97a008430010267cf32f9f7a"

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
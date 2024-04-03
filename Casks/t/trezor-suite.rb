cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.3.4"
  sha256 arm:   "f00103d946b34978d167562c1153c2249cd6c912fbd887bf7df124d793d5dde8",
         intel: "1db6257f9b61ed2366a2cff69527e739272137ae89c368b6412989a97f70280d"

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
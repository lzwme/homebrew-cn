cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.2.4"
  sha256 arm:   "78ad5c31db8034129a2664ab4012441906f7cabd2624247e57e90c48d518eff2",
         intel: "7ccb75097496d72f736e1d73e46a1ff4621300868ce273f7acaac2faeb7e2988"

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
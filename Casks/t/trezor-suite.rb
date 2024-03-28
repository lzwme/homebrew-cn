cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.3.3"
  sha256 arm:   "3ccae180aaa1b680d3b93cf6100269b6728e823ebfbd6244930f4c9a4931b4a4",
         intel: "640a87b7a90f182ba020f5ac4b044e23800660cd10c9c8ae5e17e463421e0436"

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
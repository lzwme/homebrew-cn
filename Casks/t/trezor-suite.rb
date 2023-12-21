cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "23.12.3"
  sha256 arm:   "1a7dc47e010f0c0f46e4fb5bd93643fd89e2331c45c3f074859981b5a740979f",
         intel: "fc9251ef3b96acd736934a31ca47add144016f580239e5e2e02ad8520210370a"

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
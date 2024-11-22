cask "trezor-suite" do
  arch arm: "arm64", intel: "x64"

  version "24.11.2"
  sha256 arm:   "54846611e4a666fc158ab2a2adc3249c749402722b4542f511571b7c4a200971",
         intel: "cf338632801a101bf25bbaff3153f818544a00da8cbe83959e47cca8b03351f9"

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
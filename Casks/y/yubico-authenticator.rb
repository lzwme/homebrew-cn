cask "yubico-authenticator" do
  version "7.1.1"
  sha256 "142b7fbdfe3a49f6e9c23f8951243e829ee082acd209d12f15ac2df8e48e4969"

  url "https:github.comYubicoyubioath-flutterreleasesdownload#{version}yubico-authenticator-#{version}-mac.dmg",
      verified: "github.comYubicoyubioath-flutterreleasesdownload"
  name "Yubico Authenticator"
  desc "Application for generating TOTP and HOTP codes"
  homepage "https:developers.yubico.comyubioath-flutter"

  depends_on macos: ">= :big_sur"

  app "Yubico Authenticator.app"

  zap trash: [
    "~LibraryApplication Scriptscom.yubico.authenticator",
    "~LibraryContainerscom.yubico.authenticator",
  ]
end
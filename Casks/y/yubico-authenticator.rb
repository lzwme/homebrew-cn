cask "yubico-authenticator" do
  version "6.4.0"
  sha256 "be193c17ad7844366fcc676cc62a6de8c2a2f1f23e14f0f5564169dc34eeb0c8"

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
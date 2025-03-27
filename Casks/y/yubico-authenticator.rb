cask "yubico-authenticator" do
  version "7.2.0"
  sha256 "45ffd19c7d187f010856de4ec18d802518bc6ba1fe590ce937b3e809998f8309"

  url "https:github.comYubicoyubioath-flutterreleasesdownload#{version}yubico-authenticator-#{version}-mac.dmg",
      verified: "github.comYubicoyubioath-flutterreleasesdownload"
  name "Yubico Authenticator"
  desc "Application for generating TOTP and HOTP codes"
  homepage "https:developers.yubico.comyubioath-flutter"

  depends_on macos: ">= :catalina"

  app "Yubico Authenticator.app"

  zap trash: [
    "~LibraryApplication Scriptscom.yubico.authenticator",
    "~LibraryContainerscom.yubico.authenticator",
  ]
end